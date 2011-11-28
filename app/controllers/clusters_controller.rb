class ClustersController < ApplicationController
  layout 'adminlayout'
  #  before_filter :login_required
  def index
    @clusters = Cluster.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  #  def show
  #    @cluster = Cluster.find(params[:id])
  #  end

  def new
    @cluster = Cluster.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @cluster = Cluster.new(params[:cluster])
    respond_to do |format|
      if @cluster.save
        flash[:notice] = '<font color=green size=4><b>GROUP WAS SUCCESSFULLY CREATED.</b></font>'
        format.html { redirect_to clusters_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @cluster = Cluster.find(params[:id])
  end

  def update
    debugger
    @cluster = Cluster.find(params[:id])
    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        flash[:notice] = '<font color=green size=4><b>GROUP WAS SUCCESSFULLY UPDATED.</b></font>'
        format.html { redirect_to(clusters_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    Cluster.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to(clusters_path) }
    end
  end

  #  def canceladd
  #    render :update do |page|
  #      format.html { redirect_to(clusters_url) }
  ##      page.redirect_to url_for(:controller=>'clusters', :action=>'list')
  #    end
  #  end
end
