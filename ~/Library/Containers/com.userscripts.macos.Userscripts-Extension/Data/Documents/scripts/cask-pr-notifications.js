// ==UserScript==
// @name        Cask PR Notifications
// @description Mark merged version bump PRs as read.
// @match       https://github.com/notifications*
// @run-at      document-end
// @inject-into auto
// ==/UserScript==

const listItems = document.querySelectorAll('.notifications-list-item')

let readItems = 0;

for (const listItem of listItems) {
  const link = listItem.querySelector('.notification-list-item-link')

  const title = listItem.querySelector('.m-0.text-normal.pr-2.pr-md-0').textContent
  const update = title.includes("Update ") && title.includes(" to ")
  const icon = link.querySelector('.octicon')
  const merged = icon.classList.contains('octicon-git-merge')

  if (update && merged) {
    const doneButton = listItem.querySelector('.notification-action-mark-archived button[type="submit"]')
    doneButton.click()

    console.log(`Marked '${title}' as read.`)

    readItems++;
  }
}

console.log(`Marked ${readItems}/${listItems.length} notifications as read.`)
