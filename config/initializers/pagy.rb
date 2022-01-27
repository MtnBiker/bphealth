require 'pagy/extras/bootstrap'
# Trying for user setting of number of items but didn't quite figure it out. https://ddnexus.github.io/pagy/extras/items.html#items-extra
require 'pagy/extras/items'
Pagy::DEFAULT[:items_param] = :custom_param
Pagy::DEFAULT[:max_items]   = 50
Pagy::DEFAULT[:gearbox_items] = [50, 100] # more items per page as you dive in, but not working, so I'm missing something.