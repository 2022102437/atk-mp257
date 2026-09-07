/*
 * driver_deps.c    TTTech DEIP Driver-specific code.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version
 *  2 of the License, or (at your option) any later version.
 *
 * Authors: Juergen Wohlmuth <juergen.wohlmuth@tttech.com>
 */

#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <asm/byteorder.h>

#include "log.h"
#include "mstp.h"

#include <dlfcn.h>
#include <errno.h>
#include "mstp_tsn.h"
#include "mstp_tsn_private.h"


/* Initialize driver objects & states */
int driver_mstp_init()
{
    /* Nothing to do here */
    return 0;
}

/* Cleanup driver objects & states */
void driver_mstp_fini()
{
    /* Nothing to do here */
    return;
}

/* Driver hook that is called before a bridge is created */
bool driver_create_bridge(bridge_t *br, __u8 *macaddr)
{
    /* Nothing to do here - bridge exists */
    return true;
}

/* Driver hook that is called before a port is created */
bool driver_create_port(port_t *prt, __u16 portno)
{
    /* Nothing to do here - port exists */
    return true;
}

/* Driver hook that is called when a bridge is deleted */
void driver_delete_bridge(bridge_t *br)
{
    /* Nothing to do here - bridge exists */
}

/* Driver hook that is called when a port is deleted */
void driver_delete_port(port_t *prt)
{
    /* Nothing to do here - port exists */
}


bool driver_set_fid2mstid(bridge_t *br, __u16 fid, __u16 mstid)
{
    bool ret = false;
    struct port_hdl *ph = tsn_port_open_by_name(br->sysdeps.name);
    ret = (tsn_mstp_set_fid_to_msti(ph, fid, mstid) == 0 ? true : false);
    tsn_port_close(ph);
    return ret;
}

bool driver_set_vid2fid(bridge_t *br, __u16 vid, __u16 fid)
{
    bool ret = false;
    struct port_hdl *ph = tsn_port_open_by_name(br->sysdeps.name);
    ret = (tsn_qbridge_set_vid2fid(ph, vid, fid) == 0 ? true : false);
    tsn_port_close(ph);
    return ret;
}

/*
 * Set new state (BR_STATE_xxx) for the given port and MSTI.
 * Return new actual state (BR_STATE_xxx) from driver.
 */
int driver_set_new_state(per_tree_port_t *ptp, int new_state)
{
    int ret = -1;
    /* TODO: use <port>/iee8021Mstp/treePortState object */
    struct port_hdl *ph = tsn_port_open_by_name(ptp->port->sysdeps.name);
    ret = (tsn_mstp_set_port_state(ph, __be16_to_cpu(ptp->MSTID), new_state) == 0 ? new_state : ret);
    tsn_port_close(ph);
    return ret;
}

bool driver_create_msti(bridge_t *br, __u16 mstid)
{
    // THIS IS ACTUALLY THE BRIDGE, NOT A PORT PER SE
    bool ret = false;
    struct port_hdl *ph = tsn_port_open_by_name(br->sysdeps.name);
    /* TODO: use <bridge>/iee8021Mstp/createMsti object */
    ret = (tsn_mstp_create_msti(ph, mstid) == 0 ? true : false);
    tsn_port_close(ph);
    return ret;
}

bool driver_delete_msti(bridge_t *br, __u16 mstid)
{
    // THIS IS ACTUALLY THE BRIDGE, NOT A PORT PER SE
    bool ret = false;
    struct port_hdl *ph = tsn_port_open_by_name(br->sysdeps.name);
    /* TODO: use <bridge>/iee8021Mstp/deleteMsti object */
    ret = (tsn_mstp_delete_msti(ph, mstid) == 0 ? true : false);
    tsn_port_close(ph);
    return ret;
}

void driver_flush_all_fids(per_tree_port_t *ptp)
{
    struct port_hdl *ph = tsn_port_open_by_name(ptp->port->sysdeps.name);
    tsn_mstp_flush_tree_port(ph, __be16_to_cpu(ptp->MSTID));
    tsn_port_close(ph);
    MSTP_IN_all_fids_flushed(ptp);
}

/*
 * Set new ageing time (in seconds) for the port.
 * Return new actual ageing time from driver (the ageing timer granularity
 *  in the hardware can be more than 1 sec)
 */
unsigned int driver_set_ageing_time(port_t *prt, unsigned int ageingTime)
{
    /* Not supported */
    return ageingTime;
}


/* sysfs port handlers */
struct port_hdl* tsn_port_open_by_name(const char *ifname) {
    struct port_hdl* phdl = NULL;
    if (if_nametoindex(ifname) != 0) {
        phdl = malloc(sizeof(*phdl));
        if (phdl) {
            strcpy(phdl->sysfs_path, SYSFS_PORT_BASE);
            strcat(phdl->sysfs_path, ifname);
        }
    }
    return phdl;
}

void tsn_port_close(struct port_hdl *phdl) {
    if (phdl)
        free(phdl);
}

/* mstp stuff */


int tsn_mstp_flush_tree_port (struct port_hdl *port, unsigned int mstid)
{
    FILE *fp;
    unsigned int max_msti = 0;
    struct port_hdl master_br = *port;
    strcat(master_br.sysfs_path, "/master");
    if(tsn_mstp_get_max_msti(&master_br, &max_msti) < 0)
        return -ENOENT;
    if (mstid > _MAX_MSTID)
        return -ERANGE;
    ASSERT_OPEN(fp, port, mstp_fn[FLUSH_TREE], "w");
    ASSERT_PRINT(fp, "%u", mstid);
    return fclose(fp);
}

int tsn_mstp_create_msti (const struct port_hdl *port, const unsigned int mstid)
{
    FILE *fp;
    unsigned int max_msti = 0;
    if(tsn_mstp_get_max_msti(port, &max_msti) < 0)
        return -ENOENT;
    if (mstid > _MAX_MSTID)
        return -ERANGE;
    ASSERT_OPEN(fp, port, mstp_fn[CREATE_MSTI], "w");
    ASSERT_PRINT(fp, "%u", mstid);
    return fclose(fp);
}

int tsn_mstp_delete_msti (const struct port_hdl *port, const unsigned int mstid)
{
    FILE *fp;
    unsigned int max_msti = 0;
    if(tsn_mstp_get_max_msti(port, &max_msti) < 0)
        return -ENOENT;
    if (mstid > _MAX_MSTID)
        return -ERANGE;
    ASSERT_OPEN(fp, port, mstp_fn[DELETE_MSTI], "w");
    ASSERT_PRINT(fp, "%u", mstid);
    return fclose(fp);
}

int tsn_mstp_set_fid_to_msti (const struct port_hdl *port, const unsigned int fid, const unsigned int mstid)
{
    FILE *fp;
    unsigned int max_msti = 0;
    unsigned int max_fid = 0;
    if(tsn_mstp_get_max_msti(port, &max_msti) < 0)
        return -ENOENT;
    if(tsn_qbridge_get_max_supported_vlans(port, &max_fid) < 0)
        return -ENOENT;
    if ((mstid > _MAX_MSTID) || (fid > max_fid))
        return -ERANGE;
    ASSERT_OPEN(fp, port, mstp_fn[SET_FID2MSTI], "w");
    ASSERT_WRENTRY(fp, mstid, fid);
    return fclose(fp);
}

int tsn_mstp_set_port_state (const struct port_hdl *port, const unsigned int mstid, const port_mstp_state port_state)
{
    FILE *fp;
    unsigned int state = (unsigned int) port_state;
    unsigned int max_msti = 0;
    struct port_hdl master_br = *port;
    strcat(master_br.sysfs_path, "/master");
    if(tsn_mstp_get_max_msti(&master_br, &max_msti) < 0)
        return -ENOENT;
    if (mstid > _MAX_MSTID)
        return -ERANGE;
    ASSERT_OPEN(fp, port, mstp_fn[SET_PORT_STATE], "w");
    ASSERT_WRENTRY(fp, state, mstid);
    return fclose(fp);
}

/* qbridge stuff */
int tsn_qbridge_set_vid2fid(struct port_hdl *bridge, uint32_t vid, uint32_t fid)
{
    FILE *fp;
    unsigned int max_vid = 0;
    unsigned int max_fid = 0;
    if(tsn_qbridge_get_max_vlan_id(bridge, &max_vid) < 0)
        return -ENOENT;
    if(tsn_qbridge_get_max_supported_vlans(bridge, &max_fid) < 0)
        return -ENOENT;
    if ((vid > max_vid) || (fid > max_fid))
        return -ERANGE;
    ASSERT_OPEN(fp, bridge, qbridge_fn[VID2FID_TABLE], "w");
    ASSERT_WRENTRY(fp, fid, vid);
    return fclose(fp);
}

/* miscellaneous functions */

int tsn_qbridge_get_max_vlan_id(struct port_hdl *bridge, uint32_t *max_vlan_id)
{
    FILE *fp;
    ASSERT_OPEN(fp, bridge, qbridge_fn[MAX_VLAN_ID], "r");
    ASSERT_SCAN(fp, "%u", 1, max_vlan_id);
    return fclose(fp);
}

int tsn_qbridge_get_max_supported_vlans(const struct port_hdl *bridge, uint32_t *max_supported_vlans)
{
    FILE *fp;
    ASSERT_OPEN(fp, bridge, qbridge_fn[MAX_SUPPORTED_VLANS], "r");
    ASSERT_SCAN(fp, "%u", 1, max_supported_vlans);
    return fclose(fp);
}

int tsn_mstp_get_max_msti (const struct port_hdl *port, unsigned int * const num_msti)
{
    FILE *fp;
    ASSERT_OPEN(fp, port, mstp_fn[MAX_MSITD], "r");
    ASSERT_SCAN(fp, "%u", 1, num_msti);
    return fclose(fp);
}

