require 'json'
require 'rest-client'
require 'uri'
require 'dgi/identity'

class Memory

  def initialize()
    @escp = {
      'dev' =>  'http://event-service-consumer-proxy.apps.10.52.46.151.xip.io/metrics',
      'devint' => 'https://event-service-consumer-proxy.devint.apps.cfdev1.ux.dg.local/metrics',
      'int' => 'https://event-service-consumer-proxy.int.apps.cfdev1.ux.dg.local/metrics',
      'reg' => 'https://event-service-consumer-proxy.reg.apps.cfdev1.ux.dg.local/metrics'
    }
    @es = {
      'dev' =>  'http://event-service.apps.10.52.46.151.xip.io/metrics',
      'devint' => 'https://event-service.devint.apps.cfdev1.ux.dg.local/metrics',
      'int' => 'https://event-service.int.apps.cfdev1.ux.dg.local/metrics',
      'reg' => 'https://event-service.reg.apps.cfdev1.ux.dg.local/metrics'
    }
    @ssoLink = {
      'dev' => 'http://sso.apps.10.52.46.151.xip.io',
      'devint' => 'https://sso.login.sys.cfdev1.ux.dg.local',
      'int' => 'https://sso.login.sys.cfdev1.ux.dg.local',
      'reg' => 'https://sso.login.sys.cfdev1.ux.dg.local'
    }
    @clientIds = {
      'dev' => '-rqlnQPikN0W',
      'devint' => 'ErSi5qRMe2E-',
      'int' => 'ErSi5qRMe2E-',
      'reg' => 'ErSi5qRMe2E-'
    }
    @clientSecrets = {
      'dev' => 'XS0AOo6_Ff-KK0_0VoN_',
      'devint' => 'RjnYQGbZHir4tpDn-0Lc',
      'int' => 'RjnYQGbZHir4tpDn-0Lc',
      'reg' => 'RjnYQGbZHir4tpDn-0Lc'
    }
  end

  def read_xml( application, environment )
      if application == 'escp'
          response = JSON.parse(RestClient.get @escp[environment], getHeader(environment))
      else
          response = JSON.parse(RestClient.get @es[environment], getHeader(environment))
      end
      newMetric = Metric.new()
      newMetric.memory = response['mem']
      newMetric.memoryFree = response['mem.free']
      newMetric.processors = response['processors']
      newMetric.heapCommited = response['heap.committed']
      newMetric.heapInit = response['heap.init']
      newMetric.heapUsed = response['heap.used']
      newMetric.threads = response['threads']
      newMetric.uptime = response['uptime']
      newMetric.environment = environment
      newMetric.application = application
      newMetric.save
  end

  def getHeader(environment)
    header = { :Content_Type => 'application/json', :Authorization => 'Bearer '+ getToken(environment)}
    return header
  end

  def getToken(environment)
    DGI::Identity::get_token(@ssoLink[environment], @clientIds[environment], @clientSecrets[environment])
  end
end
