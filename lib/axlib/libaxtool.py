"""
axlib.libaxtool (residing in libaxtool.py)
main class for the axtool command

this class is created, and ran
it retur    ns a single value that is passed
back to the operating system in the form
of a numeric error code:

INT Value     Meaning
--------------------------
0             NO ERRORS/OK
1             ERRORS (GENERIC)
[2-256]       Undocumented/Unused

values above 1 are reserved but could be used
before documented. If it isn't documented it
probably means that the error is so generic that
it does not warrant a separate meaning, but
a separate value was needed.
"""

class commandHandler:
"""
commandHandler
the main handler for the libaxtool module
it is responsible for grabbing the command line
and outputs a response on stdout/stderr, it's return
status is stored in it's resultCode attribute.
"""
    def __init__(self, *arguments):
        # guilty until proven innocente'
        self.resultCode = 1
        if (length(arguments)):
            self.resultCode = 0
            pass
        else:
            print("No Arguments")
    def getResultCode(self->commandHandler)->int:
        return self.resultCode


# UNIT TESTING
# Used to test the class on it's own

if (__name__ == "__main__"):
    # test banner/version info
    # test criteria
    testCases = 2
    testPasses = 0
    # test evaluation
    testPasses + (1 if commandHandler("") == 0 else 0)
    testPasses + (1 if commandHandler([]) == 1 else 0)
    # report failures
    if (testCases > testPasses):
        print("WARNING: self-test failed, please contact administrator for reinstallation.")
        print("         if it seems to be bug related, please contact the code's author.")
    else:
        print("OK")
