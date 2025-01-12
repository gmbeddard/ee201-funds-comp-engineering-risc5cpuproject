
// Since we're compiling without the standard library, gcc is going to look for
// a function called `_start()` to be the beginning of our program.
void _start()
{
  int x = 5;
  x = x + 3;
  x = x * 2;
}

