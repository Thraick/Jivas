:walker:apply_whitelist_action:can:apply_whitelist_action {
    if (here.enabled) {
        print("Applying whitelist action");
        print("Session ID: " + session_id);
        if (session_id in here.whitelist) {
            return True;
        } else {
            return False;
        }
    } else {
        print("Whitelist action is disabled");
        return True;
    }
}