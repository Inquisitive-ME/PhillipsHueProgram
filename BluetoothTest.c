#include <stdio.h>
#include <errno.h>
#include <ctype.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <signal.h>

#include "bluetooth/bluetooth.h"
#include "bluetooth/hci.h"
#include "bluetooth/hci_lib.h"

//#include "src/oui.h"
static void cmd_rssi(int dev_id, int argc, char **argv)
{
	struct hci_conn_info_req *cr;
	bdaddr_t bdaddr;
	int8_t rssi;
	int opt, dd;

	for_each_opt(opt, rssi_options, NULL) {
		switch (opt) {
		default:
			printf("%s", rssi_help);
			return;
		}
	}
	helper_arg(1, 1, &argc, &argv, rssi_help);

	str2ba(argv[0], &bdaddr);

	if (dev_id < 0) {
		dev_id = hci_for_each_dev(HCI_UP, find_conn, (long) &bdaddr);
		if (dev_id < 0) {
			fprintf(stderr, "Not connected.\n");
			exit(1);
		}
	}

	dd = hci_open_dev(dev_id);
	if (dd < 0) {
		perror("HCI device open failed");
		exit(1);
	}

	cr = malloc(sizeof(*cr) + sizeof(struct hci_conn_info));
	if (!cr) {
		perror("Can't allocate memory");
		exit(1);
	}

	bacpy(&cr->bdaddr, &bdaddr);
	cr->type = ACL_LINK;
	if (ioctl(dd, HCIGETCONNINFO, (unsigned long) cr) < 0) {
		perror("Get connection info failed");
		exit(1);
	}

	if (hci_read_rssi(dd, htobs(cr->conn_info->handle), &rssi, 1000) < 0) {
		perror("Read RSSI failed");
		exit(1);
	}

	printf("RSSI return value: %d\n", rssi);

	free(cr);

	hci_close_dev(dd);
}

int main(void){
	printf("HELLO WORLD\n");

	return 1;
}

//curl -H "Accept: application/json" -X PUT --data '{"on":true}' 

