---
layout: post
title: The promise handler pattern
date: '2014-07-05T12:14:00+03:00'
tags: [js]
categories: []
---
The common way I’ve seen JS promises being explained is something like this:

```js
doSomeAsyncTask()
.then(function(value) {
	doSomethingUsefulWith(value);
})
.catch(function(error) {
	logTheErrorAndRecoverInSomeWayFromThe(error);
});
```

It looks OK when taken in isolation, but when in the context of more code, it quickly beginns to look hairy. Here is an example in my side project:

```js
$scope.authenticate = function() {
	delete $scope.passwordError;
	delete $scope.emailError;
	delete $scope.unknownError;

	$scope.isAuthenticationInProgress = true;
	var useCase = XO.userAuthenticationUseCase;
	var eventName;

	useCase.authenticate($scope.email, $scope.password)
	.then(function() {
		$rootScope.isAuthenticated = true;
		eventName = 'authentication succeeded';
	})
	.catch(function(error) {
		var errorSubject;

		if (error.message.match(/email/)) {
			errorSubject = 'email';
			form.emailField.focus();
		} else if (error.message.match(/parola/)) {
			errorSubject = 'password';
			form.passwordField.focus();
		} else {
			errorSubject = 'unknown';
		}

		$scope[errorSubject + 'Error'] = error.message;
		eventName = 'authentication failed';
	})
	.finally(function() {
		delete $scope.isAuthenticationInProgress;
		$scope.$apply();
		form.emit(eventName);
	});
};
```

Um… this is too big of a chunk. If I would explain this code to a
colleague I would say something like: “This is where we handle the
results of authentication. This is the success case, this is the failure
case, and this is what we want to do in any case.” Hm… this sounds
better… Maybe we can say it as concise in the code… ?

It seems that all these three pieces are logically related: they are
specific parts of the same workflow: handling the results of a promise
execution, so maybe it makes sense to have an object… a promise handler?
I’d like to be able to say it like this:

```js
$scope.authenticate = function() {
	var useCase = XO.userAuthenticationUseCase;
	var handler = new AuthenticationHandler(form, $scope, $rootScope);

	useCase.authenticate($scope.email, $scope.password)
	.then(handler.announceSuccess)
	.catch(handler.handleFailure)
	.finally(handler.finalize);
};
```

This reads better! I have extracted those pieces in a separate object
and passed its constructor the other relevant pieces.

I’m going to apply this to the registration form too.
