window.app.service("profilesService", ["$http", "$q", function($http, $q){
    var getProfiles = $http.get("/profiles").then(function(response){
            service.list = response.data;
            service.waiting = false;
            return response.data;
        }),
        service = {
        list: [],
        waiting: true,
        current: undefined,
        all : function(){
            return getProfiles.then();
        },
        findByName : function(name){
            return getProfiles.then(function(){
                for(var i =0; i< service.list.length; i++){
                    if(service.list[i].name == name){
                        service.current = service.list[i];
                        return service.current;
                    }
                }
            });
        },
        updateSchema : function(){
            var self = this;
            return $http.get("/schema").then(function(response){
                self.schema = response.data;
                return response.data;
            });
        },
        getFile: function (profileName, fileName) {
            var self = this;
            self.fileEditing = null;
            return $http.get("/profiles/"+profileName+"/files/"+fileName).then(function(response){
                self.fileEditing = response.data;
                return response.data;
            });

        }

    };
    return service
}]);
