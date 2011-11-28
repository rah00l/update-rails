class PreviousrecordsController < ApplicationController
    
    layout 'adminlayout'
     before_filter :login_required
def search
    begin
    puts "in search"
    @session['obcluster']=params[:shop][:ClusterName]
    redirect_to :action=>'list'
    rescue Exception=>ex
        puts ex.message
    end
end


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @previousrecord_pages, @previousrecords = paginate :previousrecords, :per_page => 10
  end

  def show
    @previousrecord = Previousrecord.find(params[:id])
  end

  def new
    @previousrecord = Previousrecord.new
  end

  def create
    @previousrecord = Previousrecord.new(params[:previousrecord])
    if @previousrecord.save
      flash[:notice] = 'Previousrecord was successfully created.'
      redirect_to :controller=>'entries', :action=>'dataentry'
    else
      render :action => 'new'
    end
  end

  def edit
    @previousrecord = Previousrecord.find(params[:id])
  end

  def update
    @previousrecord = Previousrecord.find(params[:id])
    if @previousrecord.update_attributes(params[:previousrecord])
      flash[:notice] = 'Previousrecord was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Previousrecord.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
