dropdown = () ->

  document.body.addEventListener 'click', (e) ->
    if e.target.classList.contains('menu-item') && ! e.target.classList.contains('open')
      e.target.classList.add 'open'
      document.addEventListener('click', dismiss = ->
        e.target.classList.remove 'open'
        document.removeEventListener 'click', dismiss

k$.dropdown = dropdown

module.exports = dropdown
