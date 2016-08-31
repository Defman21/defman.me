---
title: Creating a dynamic toolbar button for Komodo X
description: I'm finding side toolbar very useful for me. More over, you can write your own tools for it. So, how do you do that?
date: 201608312042
id: 201608312042-dynamic-buttons-in-komodo
tags: komodo userscripts javascript
---

What are those "dynamic buttons"? This is a new thing in Komodo **IDE** X.
Depending on different statements, these buttons will appear and disappear.
If you're editing a markdown file, a markdown dynamic button will appear in
side toolbar. I hope you get the idea.

A button could do a lot of things. You can run shell commands or do anything
else that you can do using Komodo's SDK. I'm going to write a simple button that
will show a notify contains path of current project. Why? With this idea, I'll
cover things I want to describe:

1. Statements whenever a button should appear.
2. How you can access Komodo's SDK.

Let's get started!

# Creating an userscript

This step is pretty easy - open right pane, right click - Add - New Userscript.
Name it somehow and close the popup. Then right click on the userscript -
Edit Userscript.

# The code!

The first thing we'll do is create a local scope:

```javascript
(function() {
    ...
})();
```

This helps us to avoid any conflicts with global variables. The rest of the
code will be at the `...` place.

Then, require the module:

## Requires

```javascript
const db = require('ko/dynamic-button');
```

We'll use `db` variable for registering our button.

Then, require a legacy module for accessing projects:

```javascript
const koPart = Cc["@activestate.com/koPartService;1"].getService(Ci.koIPartService);
```

We'll use it to check if there's a project opened and then get the project path.
As I said, our button will show a notification. So we need the notification
module!

```javascript
require('notify/categories').register('my_dynamic_button', {
    label: "Dynamic button"
});
```

We'll register a category for notifications, so we can use it in the future.

Now, require an actual API to send notifications:

```javascript
const notify = require('notify');
```

We're done with requiring things. Let's get into the logic!

## The logic

First, we'll create a function that will return current project path or null.

```js
var project = () => {
    if (koPart.currentProject !== null) { // check if a project is opened
        return koPart.currentProject.liveDirectory;
    } else {
        return null;
    }
};
```

Then, we register our button:

```javascript
const button = db.register({
    label: "My button",
    tooltip: "Tooltip for my button",
    icon: "cloud", // a nice cloud
    events: [
        "current_view_changed",
        "current_place_opened",
        "file_saved"
    ], // the list of events that will fire isEnabled function
       // note it's optional, if you don't specify this varialbe the list will be the same
    isEnabled: () => { // our checking function, true enables it, false disables it
        return project() !== null;
    },
    command: () => {
        notify.send(`Button: path: ${project()}`, {
            priority: "info",
            category: "my_dynamic_button"
        });
    }
});
```

And... done! Now run your userscript. If you don't see a cloud icon in your
side toolbar, you didn't open a project then. That's our check right there!

When you click on it, a notification will appear (probably in the top of your
editor, inside Commando thing).

A more complicated button with a menu will be reviewed very soon! I just wanted
to give some basics about that because it's not documented anywhere.

# The final code

```javascript
(function() {
    const db = require('ko/dynamic-button');
    const koPart = Cc["@activestate.com/koPartService;1"].getService(Ci.koIPartService);
    require('notify/categories').register('my_dynamic_button', {
        label: "Dynamic button"
    });
    const notify = require('notify');
    
    var project = () => {
        if (koPart.currentProject !== null) {
            return koPart.currentProject.liveDirectory;
        } else {
            return null;
        }
    };
    
    const button = db.register({
        label: "My button",
        tooltip: "Tooltip for my button",
        icon: "cloud", // a nice cloud
        events: [
            "current_view_changed",
            "current_place_opened",
            "file_saved"
        ], // the list of events that will fire isEnabled function
           // note it's optional, if you don't specify this varialbe the list will be the same
        isEnabled: () => { // our checking function, true enables it, false disables it
            return project() !== null;
        },
        command: () => {
            notify.send(`Button: path: ${project()}`, {
                priority: "info",
                category: "my_dynamic_button"
            });
        }
    });
})();
```

### Post-Scriptum

Thanks a lot to Carey Hoffman from ActiveState for giving me actual examples
of code! (Those were private, so don't even bother! :P)

However, there is [an open-source example!](https://github.com/Komodo/KomodoEdit/blob/master/src/modules/lintresults/content/lintresults.js) (Thanks to Nathan Rijksen!)