class PagesController < ApplicationController
  def home
    @title = "Home"
    #debugger
    #x = 1  # <--- need this to stop the debugger in meaningful location after 'debugger'
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end
end
