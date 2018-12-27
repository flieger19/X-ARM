//___FILEHEADER___

#include "___VARIABLE_MICROCONTROLLER___.h"

int counter = 0;
int offset = 5;

void calc(void) {
	counter += offset;
}

int main(void) {
    // setup perifery hear

    // main loop
	while (1) {
        calc();
        // insert code hear
	}
	return 0; // never reached
}

#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line) {
    /* Infinite loop */
    /* Use the debugger to find out why we're here */
    while (1);
}
#endif
