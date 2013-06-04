Angular-InlineEdit
==================

InlineEdit directive for AngularJS. Adds the ability to wrap any input field with a read-only label view.

To Build:
	InlineEdit is written in CoffeeScript and will need to be compiled to Javascript before importing into your project. 

	You can do this using the include Cakefile. by running the command:

		`cake build`



Example:

	# Add 'InlineEdit' as a dependency for your app
	myapp = angular.module("Myapp", ["InlineEdit"])

	<!-- Bind the display value to the same field as the input field -->
	<input ng:model="person.name" cb:inline/>

	<-- Display a different value to the ng:model binding --> 
	<select ng:model="person.countryId" 
	        ng:options="country.Id as country.Name for country in countries"
			cb:inline="countryName( person.countryId)"
	/>

	
