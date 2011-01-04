class CachesController < ApplicationController
  # GET /caches
  # GET /caches.xml
  def index
    @caches = Cache.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @caches }
    end
  end

  # GET /caches/1
  # GET /caches/1.xml
  def show
    @cache = Cache.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cache }
    end
  end

  # GET /caches/new
  # GET /caches/new.xml
  def new
    @cache = Cache.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cache }
    end
  end

  # GET /caches/1/edit
  def edit
    @cache = Cache.find(params[:id])
  end

  # POST /caches
  # POST /caches.xml
  def create
    @cache = Cache.new(params[:cache])

    respond_to do |format|
      if @cache.save
        flash[:notice] = 'Cache was successfully created.'
        format.html { redirect_to(@cache) }
        format.xml  { render :xml => @cache, :status => :created, :location => @cache }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /caches/1
  # PUT /caches/1.xml
  def update
    @cache = Cache.find(params[:id])

    respond_to do |format|
      if @cache.update_attributes(params[:cache])
        flash[:notice] = 'Cache was successfully updated.'
        format.html { redirect_to(@cache) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /caches/1
  # DELETE /caches/1.xml
  def destroy
    @cache = Cache.find(params[:id])
    @cache.destroy

    respond_to do |format|
      format.html { redirect_to(caches_url) }
      format.xml  { head :ok }
    end
  end
end
