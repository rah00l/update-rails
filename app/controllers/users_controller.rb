class UsersController < ApplicationController
  layout 'adminlayout'
#  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  def cancel
    render :update do |page|
      page.redirect_to url_for(:controller=>'users', :action=>'list')
    end
  end

  def canceladd
    render :update do |page|
      page.redirect_to url_for(:controller=>'users', :action=>'list')
    end
  end
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }
  def list
    @user_pages, @users = paginate :users, :per_page => 10
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def signup
    case @request.method
    when :post
      @user = User.new(@params['user'])
      if @user.save
        @session['user'] = User.authenticate(@user.login, @params['user']['password'])
        flash['notice']  = "Signup successful"
        redirect_to :action => "list"
      end
    when :get
      @user = User.new
    end      
  end  

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def delete
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def password
    @user = @session['user']
    case @request.method
    when :post
      if@params['new_password']==""     
        @msg= 'Please enter your new Password !'
      end
      if@params['old_password']==""     
        @msg= 'Please enter your old Password !'
      end
      if @params['new_password_confirmation']==""
        @msg= 'Please enter your Password again for confirmation!'
      end
      unless @user.password_check?(@params['old_password'])
        @msg= 'You have introduced a wrong old password!'
      else
        unless @params['new_password'] == @params['new_password_confirmation']
          @msg = 'Your new password and password confirmation dont match!'
        else
          @msg = 'Your password was changed successfully!' if @user.change_password(@params['new_password'])
        end
      end
    end
  end
end
