
class core:
    __core_uuid__ = "728b66b7-1f21-4f2f-bf33-867eb2659726"
    defaultname = "_unnamed"
    def __init__(self,strname,uuid_verification):
        if ( uuid_verification != core.__core_uuid__ ):
                print("fatal UUID mismatch error, assertion, stop!")
        if (strname == ""):
            self.name = defaultname
        self.name = strname[1]
        print("created instance: ",self.name)

    def execute_request(reqname,cookiepath):
        print("ignoring request: ",reqname,cookiepath)

