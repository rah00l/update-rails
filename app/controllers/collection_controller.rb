class CollectionController < ApplicationController
    
    def setFlag
      #puts "+++++++++++++++++++++=="
      #puts "+++++++++++++++++++++=="
      #puts params[:mistake][:id]
      #puts "+++++++++++++++++++++=="
      #puts "+++++++++++++++++++++=="
      a=params[:mistake][:id].to_a
      for i in 0..(a.length-1)
      @mdata=Machinedata.find(a[i])
      @mdata.flag='Y'
      @mdata.save
      end
      redirect_to :action => 'collection'
    end
    
end
