/*
 * mstp_tsn.h    TTTech DEIP Driver-specific code.
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version
 *  2 of the License, or (at your option) any later version.
 *
 * Authors: Juergen Wohlmuth <juergen.wohlmuth@tttech.com>
 */

#ifndef MSTP_TSN_H_
#define MSTP_TSN_H_

#include <stdint.h>


/* mstp sysfs related variables */
#define IEEE8021MSTP_DIR "ieee8021Mstp/"
#define _MAX_MSTID 0xFFE

typedef enum {
    FLUSH_TREE = 0u,
    MAX_MSITD,
    CREATE_MSTI,
    DELETE_MSTI,
    SET_FID2MSTI,
    SET_PORT_STATE,
    MAX_TSN_MSTP_FUNCTIONS  /* Add new indexes before MAX_TSN_FUNCTIONS and add related filename on sysfs_files */
} mstp_fct;

#define _MAX_MSTID 0xFFE

/** @ingroup internal
    Port handler with sysfs port path */
typedef char sysfs_fn[FILENAME_MAX];

static const sysfs_fn mstp_fn[MAX_TSN_MSTP_FUNCTIONS] = {
    [FLUSH_TREE]        = IEEE8021MSTP_DIR"flushTree",
    [MAX_MSITD]         = IEEE8021MSTP_DIR"maxMsti",
    [CREATE_MSTI]       = IEEE8021MSTP_DIR"createMsti",
    [DELETE_MSTI]       = IEEE8021MSTP_DIR"deleteMsti",
    [SET_FID2MSTI]      = IEEE8021MSTP_DIR"fid2msti",
    [SET_PORT_STATE]    = IEEE8021MSTP_DIR"treePortState",
};

/* qbridge sysfs related variables */
#define IEEE8021QBRIDGE_DIR "ieee8021QBridge/"

typedef enum {
    MAX_VLAN_ID = 0u,
    MAX_SUPPORTED_VLANS,
    VID2FID_TABLE,
    MAX_TSN_QBRIDGE_FUNCTIONS
} qbridge_fct;

static const sysfs_fn qbridge_fn[MAX_TSN_QBRIDGE_FUNCTIONS] = {
    [MAX_VLAN_ID]         = IEEE8021QBRIDGE_DIR"MaxVlanId",
    [MAX_SUPPORTED_VLANS] = IEEE8021QBRIDGE_DIR"MaxSupportedVlans",
    [VID2FID_TABLE]       = IEEE8021QBRIDGE_DIR"vid2fid",
};

/* port states enum for mstp */
typedef enum {
    PORT_DISABLED   = 0,
    PORT_LISTENING  = 1,
    PORT_LEARNING   = 2,
    PORT_FORWARDING = 3,
    PORT_BLOCKING   = 4,
    MAX_PORT_STATES = 5,
} port_mstp_state;


/* sysfs port handlers */
struct port_hdl* tsn_port_open_by_name(const char *ifname);

void tsn_port_close(struct port_hdl *phdl);

/* mstp port sysfs api */
int tsn_mstp_flush_tree_port (struct port_hdl *port, unsigned int mstid);

int tsn_mstp_set_port_state (const struct port_hdl *port, const unsigned int mstid, const port_mstp_state port_state);

/* mstp msti sysfs api */
int tsn_mstp_create_msti (const struct port_hdl *port, const unsigned int mstid);

int tsn_mstp_delete_msti (const struct port_hdl *port, const unsigned int mstid);

/* fid to mstid sysfs api */
int tsn_mstp_set_fid_to_msti (const struct port_hdl *port, const unsigned int fid, const unsigned int mstid);

/* vid to fid sysfs api */
int tsn_qbridge_set_vid2fid(struct port_hdl *bridge, uint32_t vid, uint32_t fid);

/* miscellaneous functions */
int tsn_qbridge_get_max_vlan_id(struct port_hdl *bridge, uint32_t *max_vlan_id);

int tsn_qbridge_get_max_supported_vlans(const struct port_hdl *bridge, uint32_t *max_supported_vlans);

int tsn_mstp_get_max_msti (const struct port_hdl *port, unsigned int * const num_msti);
#endif
