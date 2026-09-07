#ifndef MSTP_TSN_PRIVATE_H_
#define MSTP_TSN_PRIVATE_H_

#include <linux/limits.h>

#define SYSFS_PORT_BASE "/sys/class/net/"

/** @ingroup internal
    Port handler with sysfs port path */
struct port_hdl {
    char sysfs_path[PATH_MAX];
};

#define ASSERT_OPEN(fp, port, fn, mode)                                 \
    do {                                                                \
        char _buf[PATH_MAX+FILENAME_MAX+1];                                          \
        sprintf (_buf, "%s/%s", port->sysfs_path, fn);                  \
        if ((fp = fopen(_buf, mode)) == NULL)                           \
            return -1;                                                  \
        /* disable stdc file buffering */                               \
        setvbuf(fp, NULL, _IONBF, 0);                                   \
    } while(0)

#define ASSERT_SCAN(fp, fmt, items, ...)                                \
    do {                                                                \
        if (fscanf(fp, fmt, __VA_ARGS__) != items) {                    \
          fclose(fp);                                                   \
          return -1;                                                    \
        }                                                               \
    } while(0)

#define ASSERT_PRINT(fp, fmt, ...)                                      \
    do {                                                                \
        if (fprintf(fp, fmt, __VA_ARGS__) < 0) {                        \
            fclose(fp);                                                 \
            return -1;                                                  \
        }                                                               \
    } while(0)

#define ASSERT_WRENTRY(fp, v, idx)                                      \
    do {                                                                \
        fseek(fp, idx * sizeof(v), SEEK_SET);                           \
        if (fwrite(&v, sizeof(v), 1, fp) != 1) {                        \
            fclose(fp);                                                 \
            return -1;                                                  \
        }                                                               \
    } while(0)

#endif
