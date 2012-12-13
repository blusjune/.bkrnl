#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>



#define TARGET_FILE	"/tmp/myfile"
#define MY_BUF_SIZE	512
#if 0
#define OPEN_FLAG	O_RDONLY|O_DIRECT
#else
#define OPEN_FLAG	O_RDONLY
#endif

int main(void)
{
	int fd = -1;
	int nbytes = 0;
	char buf[MY_BUF_SIZE];

	fd = open(TARGET_FILE, OPEN_FLAG);
	nbytes = read(fd, buf, MY_BUF_SIZE);
	close(fd);
	return 0;
}
