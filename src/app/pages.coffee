require './index'

pages =
  home:
    title: 'Home'
    href: '/'
  new:
    title: 'New Playlist'
    href: '/new'
  submit:
    title: 'Submit form'
    href: '/submit'

navOrder = [
  'home'
  'new'
]

view.fn 'navItems', (current) ->
  items = []
  for ns in navOrder
    page = pages[ns]
    items.push
      title: page.title
      href: page.href
      isCurrent: current == ns
  items[items.length - 1].isLast = true
  return items

view.fn 'pageTitle', (current) ->
  return pages[current]?.title
