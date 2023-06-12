---
layout: post
title: Google Apps Script
date: 2021-12-19 21:02 +0200
tags: []
categories: []
---

For a while, I was collecting the DMARC reports, just in case I can find something useful in them. I didn’t, but I liked the lil script that I wrote in this Apps Script from Google. It’s like VBA for Microsoft Office — if you ever heard of it. If not, it’s automation for Google apps and services.

TLDR: It was checking if there are any new messages with “DMARC Reports” label in my GMail, and if yes, then would get the attached file and put it in the “DMARC Reports” folder in my GDrive. Then send me an email with a textual report about what happened. Pretty neat! 😎

```js
// GmailApp: https://developers.google.com/apps-script/reference/gmail/gmail-app
// DriveApp: https://developers.google.com/apps-script/reference/drive/drive-app

const labelName = "DMARC reports";
const folderName = "DMARC reports";

function importReports() {
  const label = GmailApp.getUserLabelByName(labelName);

  if (label.getUnreadCount() === 0) {
    return;
  }

  let report = "";

  const say = (string) => {
    report += `\n${string}`;
    Logger.log(string);
  };

  say(`Found ${label.getUnreadCount()} new messages`);

  const unreadThreads = label.getThreads().filter((t) => t.isUnread());
  const folder = DriveApp.getFoldersByName(folderName).next();

  unreadThreads.forEach((thread) => {
    const attachment = thread.getMessages()[0].getAttachments()[0];
    const file = DriveApp.createFile(attachment.getAllBlobs()[0]);

    folder.addFile(file);
    thread.markRead();

    say(attachment.getName());
  });

  GmailApp.sendEmail("gurdiga@gmail.com", "New DMARC reports", report);
}
```

I guess one could do pretty advanced stuff with this if they use multiple Google services and need to juggle things between them. At the very least it can be another useful tool.
