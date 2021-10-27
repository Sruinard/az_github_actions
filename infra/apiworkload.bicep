param uniqueness string = 'z9pqqf'
param environment string = 'dev'

resource appserviceplan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: '${environment}-api-app-asp-${uniqueness}'
  location: 'westeurope'
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
     name: 'P1v2'
     tier: 'PremiumV2'
  }  
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${environment}-api-app-logs-${uniqueness}'
  location: 'westeurope'
}

resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${environment}-api-app-insights-${uniqueness}'
  location: 'westeurope'
  kind: 'web'  
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace.id    
  }
}


resource apiPython 'Microsoft.Web/sites@2021-02-01' = {
  name: '${environment}-api-app-api-python-${uniqueness}'
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appserviceplan.id
    httpsOnly: true    
    siteConfig: {
      cors: {
        allowedOrigins: [
          '*'
        ]
        supportCredentials: false
      }
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appinsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appinsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
        {
          name: 'ACTIVE_ENVIRONMENT'
          value: environment
        }

      ]
      
      linuxFxVersion: 'python|3.7'
      alwaysOn: false
      
    }
    clientAffinityEnabled: false    
  }  
}
