require 'dgi/identity'
require 'date'

class MetricsController < ApplicationController
  before_action :set_metric, only: [:show, :edit, :update, :destroy]

  # GET /metrics
  # GET /metrics.json
  def index
    @metrics = Metric.all

  end

  def metricsES()
    @metrics = Metric.all
    @environment ||= 'dev'
    @application ||= 'Event Service'
    @memoryList = getMemoryData()
    @heapList = getHeapData()
    @uptimeList = getUptimeData()
    @threadsList = getThreadsData()
  end

  def metricsESCP()
    @metrics = Metric.all
    @environment ||= 'dev'
    @application ||= 'Event Service Consumer Proxy'
    @memoryList = getMemoryData()
    @heapList = getHeapData()
    @uptimeList = getUptimeData()
    @threadsList = getThreadsData()
  end

  def changeEnvironmentData()
    @environment ||= params[:environment]
    @application ||= getAppName(params[:application])
    @memoryList = getMemoryData()
    @heapList = getHeapData()
    @uptimeList = getUptimeData()
    @threadsList = getThreadsData()
    render :partial => 'charts', :object => @chartLists
  end

  def getUptimeData()
    uptimeChart = Hash.new()
    myMetrics = Metric.collection.find({:environment => @environment, :application => getAppCode(@application)}).sort({id: -1}).limit(200)
    myMetrics.each do |m|
      id = m['_id'].generation_time
      uptimeChart[id] = m['uptime']
    end
    return uptimeChart
  end

  def getThreadsData()
    threadsChart = Hash.new()
    myMetrics = Metric.collection.find({:environment => @environment, :application => getAppCode(@application)}).sort({id: -1}).limit(200)
    myMetrics.each do |m|
      id = m['_id'].generation_time
      threadsChart[id] = m['threads']
    end

    return threadsChart
  end

  def getAppName(application)
    if application == 'escp'
      return 'Event Service Consumer Proxy'
    else
      return 'Event Service'
    end
  end

  def getHeapData()
    heapLists = Hash.new()
    heapCommitedChart = Hash.new()
    heapInitChart = Hash.new()
    heapUsedChart = Hash.new()
    myMetrics = Metric.collection.find({:environment => @environment, :application => getAppCode(@application)}).sort({id: -1}).limit(200)
    myMetrics.each do |m|
      id = m['_id'].generation_time
      heapCommitedChart["#{id}"] = m['heapCommited']
      heapInitChart["#{id}"] = m['heapInit']
      heapUsedChart["#{id}"] = m['heapUsed']
    end
    heapLists["heapCommited"] = heapCommitedChart
    heapLists["heapInit"] = heapInitChart
    heapLists["heapUsed"] = heapUsedChart
    return heapLists
  end

  def getMemoryData()
    memoryLists = Hash.new()
    memoryFreeChart = Hash.new()
    memoryChart = Hash.new()
    myMetrics = Metric.collection.find({:environment => @environment, :application => getAppCode(@application)}).sort({id: -1}).limit(200)
    myMetrics.each do |m|
      id = m['_id'].generation_time
      puts "memory values => #{m.inspect}"
      memoryFreeChart["#{id}"] = m['memoryFree']
      memoryChart["#{id}"] = m['memory']
    end
    memoryLists["memoryFreeChart"] = memoryFreeChart
    memoryLists["memoryChart"] = memoryChart
    puts "aaaa #{memoryLists}"
    return memoryLists
  end

  def getAppCode(appName)
    if appName == 'Event Service'
      return 'es'
    else
      return 'escp'
    end
  end
  # GET /metrics/1
  # GET /metrics/1.json
  def show
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # GET /metrics/1/edit
  def edit
  end

  # POST /metrics
  # POST /metrics.json
  def create
    @metric = Metric.new(metric_params)

    respond_to do |format|
      if @metric.save
        format.html { redirect_to @metric, notice: 'Metric was successfully created.' }
        format.json { render :show, status: :created, location: @metric }
      else
        format.html { render :new }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metrics/1
  # PATCH/PUT /metrics/1.json
  def update
    respond_to do |format|
      if @metric.update_attributes(metric_params)
        format.html { redirect_to @metric, notice: 'Metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /metrics/1
  # DELETE /metrics/1.json
  def destroy
    @metric.destroy
    respond_to do |format|
      format.html { redirect_to metrics_url, notice: 'Metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset
    Metric.destroy_all
    respond_to do |format|
      format.html { redirect_to metrics_url, notice: 'Metrics were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric
      @metric = Metric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_params
      params.require(:metric).permit(:memory, :memoryFree, :processors, :heapCommited, :heapInit, :heapUsed)
    end
end
