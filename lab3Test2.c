#include "types.h"
#include "user.h"

int main(int argc, char** argv)
{
  int size = 6192;

  if(argc > 1)
    size = 8192;

  char buffer[size];
  memset(buffer, 0, size);

  printf(1, "With no kernel panic, the page unter the top of the stack was allocated.\n");
  printf(1, "%p\n", &argc);

  exit();
  return 0;
}
