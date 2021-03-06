class PaginatedArray < Array
  
  def initialize(copy_from=nil)
    self[0..copy_from.length] = copy_from if copy_from.is_a?(Array)
    @page = 1
    @per_page = 10
  end
  
  def model_name
    self
  end
  
  def human
    'PaginatedArray'
  end
  
  def order(order)
    self
  end
  
  def visible(player)
    self
  end
  def page(page)
    @page = page
    self
  end
  
  def current_page
    @page
  end
  
  def total_pages
    @page
  end
  
  def per(per_page)
    @per_page = per_page
    self
  end
  
  def each
    super
  end
  
  def all
    self
  end
  
  
end

