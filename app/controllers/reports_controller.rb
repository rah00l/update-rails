class ReportsController < ApplicationController

layout 'adminlayout'
require 'date'
#require 'facets'
before_filter :login_required

def search
    begin
    session[:ttdate1]=params[:date1]
    @session[:rrclustername]=params[:machinedata][:ClusterName]
    redirect_to :action=>'list'
        rescue Exception=>ex
    end
end

def expencereport
begin
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
 
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  
  redirect_to :action => 'exreportlist'
  rescue Exception=>ex

  end
  end


def setGroup
    begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shop'
        page << "document.getElementById('machinedata_ShopName').focus();"
        end
    rescue Exception=>exc

    end
end


def setGroup123

    begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Machinediv', :partial => 'machine1'
      p "-------------------------------"
        page << "document.getElementById('machinedata_MachineName').focus();"
        end
    rescue Exception=>exc

    end
end


def setGroupdaily 

begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
         @session[:rrclusternamedaily]=params[:ClusterName]
    end
   @clustarray=[]
    
    if(@session[:rrclusternamedaily]=="ALL")
        @group=Cluster.find(:all, :order => "ClusterName")
        
        for item in @group
            @clustarray<< item.ClusterName
        end
        len=@clustarray.length 
        @dev=[] 

        for i in 0..len-1 do
        if i==len-1
        @dev<<'\''+@clustarray[i].to_s+'\''
        else 
        @dev<<'\''+@clustarray[i].to_s+'\'' 
        @dev<<',' 
        end 
    end 
        @session[:clustarray]=@clustarray
        @session[:rrclusternamedaily]=@dev
        @session[:rrshopname]=nil
        render :update do |page|
               page.replace_html 'Shopdiv', :partial => 'shopdaily'
               page << "document.getElementById('machinedata_ShopName').options[0].selected=true;"
          end
    else
         
        @clust=[]
        @clust<<'\''+@session[:rrclusternamedaily]+'\''
        
        @session[:clustarray]=@session[:rrclusternamedaily]
        @clust=[]
        @clust<<'\''+@session[:rrclusternamedaily].to_s+'\''
        @session[:rrclusternamedaily]=nil
        @session[:rrclusternamedaily]=@clust
        @session[:rrshopname]=nil
        render :update do |page|
        page.replace_html 'Shopdiv', :partial => 'shopdaily'
        page << "document.getElementById('machinedata_ShopName').options[0].selected=true;"
        page << "document.getElementById('machinedata_ShopName').focus();"
        end
    end
    rescue Exception=>exc
        
    end
end


def setShopdaily
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
    
    rescue Exception=>ex
    end
end 



def setShop
    
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
        render :update do |page|
	      end
    rescue Exception=>exc
    
    end
end
def setShop1
    
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
    
        render :update do |page|
	      page.replace_html 'Machinediv', :partial => 'machine'
        end
    rescue Exception=>exc
    end
end



def setMName
  @session[:rrmname]=params[:MachineName]
  
end

def setMcGroup
    begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
        @session[:rrshopname]=nil
        render :update do |page|
        page.replace_html 'Shopdiv', :partial => 'shopmcsummary'
        page << "document.getElementById('machinedata_ShopName').focus();"
        end
    rescue Exception=>exc
    
    end
end

def setMcShop
  begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
        render :update do |page|
        page.replace_html 'KeyIDdiv', :partial => 'group'
        page << "document.getElementById('machinedata_GroupID').focus();"
        end
    rescue Exception=>exc

    end
end

def setKey

    begin
    
    @session[:rrgroupid]=nil
    if(params[:GroupID]!="" )
    @session[:rrgroupid]=params[:GroupID]
    end
    
    render :update do |page|
      page << "document.getElementById('save').select();"
      page << "document.getElementById('save').focus();"
   end
rescue Exception=>exc

end
end

def showdailyreport
  @clustarray=[]
  if(@session[:clusterarray]!=params[:machinedata][:ClusterName])
        if(params[:machinedata][:ClusterName]=="ALL")
        @group=Cluster.find(:all)
        
        for item in @group
            @clustarray<< item.ClusterName
        end
        len=@clustarray.length 
        @dev=[] 

        for i in 0..len-1 do
        if i==len-1
        @dev<<'\''+@clustarray[i].to_s+'\''
        else 
        @dev<<'\''+@clustarray[i].to_s+'\'' 
        @dev<<',' 
        end 
        end 
        @session[:clustarray]=@clustarray
        @session[:rrclusternamedaily]=@dev
        end
  end
  
  #CLUSTER END

  @date=params[:date]
  @day=@date.split('-');
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@day[1].to_s+'-'+@day[0].to_s)
  @session[:enddatehc]=Date.parse(@day[2].to_s+'-'+@day[1].to_s+'-'+@day[0].to_s)
  @session[:datediff]=@day[2].to_i-0
  
   
  
  @session[:enddatehc]
  
   @session[:shoparray1]=params[:machinedata][:ShopName]
   @session[:shoparray1]

   
    if(@session[:shoparray1].to_s!='ALL')
    	len=@session[:shoparray1].length
		
		@shop=[]

			for i in 0..len-1 do 
				if i==len-1 
					@shop<<'\''+@session[:shoparray1][i].to_s+'\'' 
				else 
					@shop<<'\''+@session[:shoparray1][i].to_s+'\'' 
					@shop<<',' 
				end 
			end 
    @session[:shoparray]=@shop.to_s 
    else
        @carray=@session[:clustarray].to_s
    end
 if params[:date]!=nil
  session[:dailyvalue]=Date.parse(params[:date]).strftime("%Y-%m-%d")
  #Date.parse()
  #raise Date.parse(session[:dailyvalue]).strftime("%Y-%m-%d")

  
  @machinesdata1=Machinedata.count(:conditions=>["CLUSTER_NAME in (#{@session[:rrclusternamedaily].to_s}) and SHOP_NAME in (#{@session[:shoparray].to_s}) and TRANS_DATE>='#{@session[:startdatehc]}' and TRANS_DATE<='#{@session[:enddatehc]}'"]) 
 @count=0
  if(@machinesdata1.to_i>0)
      if(params[:key]=="KEYWISE" and params[:machine]=="NAMEWISE") 
        redirect_to :action=>'displaydailyreport'
      end
      if(params[:key]=="ALLKEYS" and params[:machine]=="NAMEWISE") 
        #redirect_to :action=>'displaydailyreportallkey'
        redirect_to :action => 'displaydailyallkeyNnamewise'
      end
      if(params[:key]=="ALLKEYS" and params[:machine]=="NOWISE") 
        #redirect_to :action=>'displaydailyreportnoall'
        redirect_to :action => 'dailyreportallkeyNnowise'
      end
      if(params[:key]=="KEYWISE" and params[:machine]=="NOWISE") 
        redirect_to :action => 'dailyreportkeywisennowise'
      end
      
  else
      flash[:notice]="NO RECORD FOUND"
  render :action=>'dailyreport'
  end
  end
end

def displaydailyallkeyNnamewise

end

      def dailyreportallkeyNnowise

      end
def dailyreportkeywisennowise
	@session[:shoparray1]
end

def displaydailyreport
	@session[:shoparray1]
end


def showmachinesummaryreport
  if params[:date1]!=nil and params[:date2]!=nil
  session[:ttdate1]=params[:date1]
  session[:ttdate2]=params[:date2]
  redirect_to :action=>'showmachinesummaryreport'
  end  
end


def showshortreasonsreport
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
 
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
 
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  
end

def hcreport
  begin
  @session[:monthhc]=params[:date][:month]
  @session[:yearhc]=params[:date][:year]
  
  @session[:dayshc]=(Date.new(@session[:yearhc].to_i, 12, 31) << (12-@session[:monthhc].to_i)).day
  
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:enddatehc]=Date.parse(@session[:dayshc].to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]

  redirect_to :action => 'hcreportlist'
  rescue
  end
end

def showcounterwise

  @session[:monthhc]=params[:date][:month]
  @session[:yearhc]=params[:date][:year]
  
  @session[:dayshc]=(Date.new(@session[:yearhc].to_i, 12, 31) << (12-@session[:monthhc].to_i)).day
  
  @session[:startdatehc]=Date.parse(01.to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:enddatehc]=Date.parse(@session[:dayshc].to_s+'-'+@session[:monthhc].to_s+'-'+@session[:yearhc].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]

  
end

def shownamewisesummary
#raise params.inspect
  session[:ttdate1]=params[:date1]
  session[:ttdate2]=params[:date2]
  p "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2"
  redirect_to :action=>'showmachinenamewise'
end
def showshort
  begin
  @session[:month]=params[:date][:month]
  @session[:year]=params[:date][:year]
  @session[:days]=(Date.new(@session[:year].to_i, 12, 31) << (12-@session[:month].to_i)).day
  @session[:startdate]=Date.parse(01.to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:enddate]=Date.parse(@session[:days].to_s+'-'+@session[:month].to_s+'-'+@session[:year].to_s)
  @session[:rrclustername]=params[:machinedata][:ClusterName]
  redirect_to :action => 'showshortextra'
  rescue Exception=>ex
  
  end
end

def getShopForSE
   begin
    if(params[:ClusterName]!="" or params[:ClusterName]!=nil)
        @session[:rrclustername]=params[:ClusterName]
    end
        @session[:rrshopname]=nil
        render :update do |page|
	    page.replace_html 'Shopdiv', :partial => 'shopse'
        
        end
    rescue Exception=>exc

    end
end

def setShopSE
    
    begin
    if(params[:ShopName]!="" or params[:ShopName]!=nil)
        @session[:rrshopname]=params[:ShopName]
    end
    rescue Exception=>exc
    end
  end
  
  
def showmasterreport

  if params[:msdate]!=nil and params[:medate]!=nil
  session[:msdate]=params[:msdate]
  session[:medate]=params[:medate]
  session[:cname]=params[:machinedata][:ClusterName]
  
  redirect_to :action=>'showmaster'
  end  
end
end
