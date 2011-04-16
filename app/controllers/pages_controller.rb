class PagesController < ApplicationController
  def home
    @title = "Home"
    #debugger
    #x = 1  # <--- need this to stop the debugger in meaningful location after 'debugger'
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
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
