#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>

void help(char* name)
{
  printf("Usage:\n");
  printf("%s <IP> <PORT> \"<COMMAND>\" <TRANSPORT PROTOCOL>\n", name);
  printf("Where:\n");
  printf("IP - IPv4 like address X.X.X.X\n");
  printf("PORT - Socket port number\n");
  printf("COMMAND - Command to be send to socket surrounded by \"\n");
  printf("TRANSPORT PROTOCOL - Transport protocol to be used, TCP or UDP\n\n");
  printf("Return values:\n");
  printf("1 - Wrong arguments number\n");
  printf("2 - Could not create socket\n");
  printf("3 - Failed to connect to socket\n");
  printf("4 - Failed to send command to socket\n");
  printf("5 - Failed to set read timeout value\n");
  printf("6 - Failed to print output\n");
};

int main(int argc, char *argv[])
{
  if(argc < 4 ) 
  {
    help(argv[0]);
    return 1;
  }

  char* IP = argv[1];
  unsigned int PORT = strtol(argv[2], NULL, 0);
  char* COMMAND = argv[3];
  unsigned int CMD_LENGTH = strlen(COMMAND);
  int PROTOCOL = argv[4] != NULL  && strcmp( argv[4], "TCP" ) == 0 ? SOCK_STREAM : SOCK_DGRAM;

  int sockfd = 0,n = 0;
  char recvBuff[65535];

  memset(recvBuff, '0' ,sizeof(recvBuff));
  if((sockfd = socket(AF_INET, PROTOCOL, 0))< 0)
  {
    return 2;
  }
 
  struct sockaddr_in serv_addr;
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_port = htons(PORT);
  serv_addr.sin_addr.s_addr = inet_addr(IP);

  if(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))<0)
  {
    return 3;
  }

  if(write(sockfd, COMMAND, CMD_LENGTH) < 0)
  {
    return 4;
  }

  struct timeval tv;
  tv.tv_sec = 0;  /* 30 Secs Timeout */
  tv.tv_usec = 100000;  // Not init'ing this can cause strange errors

  if( setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (char *)&tv,sizeof(struct timeval)) > 0 )
  {
    return 5;
  }

  unsigned int buffSize = sizeof(recvBuff)-1;
  do
  {
    n = read(sockfd, recvBuff, sizeof(recvBuff)-1);

    recvBuff[n] = 0;
    if(n != -1 && fputs(recvBuff, stdout) == EOF)
    {
      return 6;
    }
  }while( n == buffSize);

  close(sockfd);

  return 0;
}
