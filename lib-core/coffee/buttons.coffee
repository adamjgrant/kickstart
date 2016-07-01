button = ->

  // Add the 'menu-item' class to all buttons that have a 'ul' child.
  ($button.classList.add 'menu-item' if $button.querySelector('button>ul')) for $button in document.querySelectorAll "button"
  // Add the 'menu-item' class to all containers that have a child with the 'button-dropdown' class
  $buttonDropdown.parentNode.classList.add 'menu-item' for $buttonDropdown in document.querySelectorAll '.button-dropdown'

k$.button = button

module.exports = button
