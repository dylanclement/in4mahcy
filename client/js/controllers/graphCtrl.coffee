window.GraphCtrl = ['$scope', '$http', ($scope, $http) ->
    @sys = arbor.ParticleSystem 1000, 800, 0.5  # create the system with sensible repulsion/stiffness/friction
    @sys.renderer = new window.GraphRenderer "#graphCanvas" # our newly created renderer will have its .init() method called shortly by sys...
    $scope.inputText = 'a dog is an animal'
    # call the rest api endpoint to get the data
    $http.get('/data/arbor').success (data) =>
      # get the nodes from the server
      $scope.data = data
      @sys.graft data

    $scope.parseText = =>
      text = $scope.inputText
      # This will do a match for the following:
      #  a dog is an animal
      #  the man is a super-hero
      match = text.match /(?:a|the)\s+(\w+)\s+is\s(?:a|an)\s+(\w+)/i
      object = match?[1]
      subject = match?[2]
      if object && subject
        $scope.object = object.toLowerCase()
        $scope.relationship = 'is_a'
        $scope.subject = subject.toLowerCase()
        # add the relationship to the graph and to the db
        $http.post("/relationship/#{$scope.object}/#{$scope.relationship}/#{$scope.subject}").success (success) =>
          @sys.addEdge $scope.object, $scope.subject, { name: $scope.relationship }
]
