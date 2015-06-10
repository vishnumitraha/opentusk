$(document).ready(function() {

	var currentTimePeriod;
	var currentTeachingSite; 
	var modificationInProgress = false;

	$("td #modify").click(function() {
		if (modificationInProgress)
		{	
			alert('Please either \'Cancel\' or \'Save\' current modifications.')
			return;
		}
		modificationInProgress = true;
		if ($(this).closest('tr').find('div#timePeriod').is(":visible"))
		{
			$(this).closest('tr').find('div#teachingSite').hide();
			$(this).closest('tr').find('div#timePeriod').hide();
			$(this).closest('tr').find('a#save').hide();
			$(this).closest('tr').find('a#cancel').hide();
			$(this).closest('tr').find('a#delete').hide();
		}
		else
		{
			currentTimePeriod = $(this).closest('tr').find('span#currentTimePeriod').text();
			currentTeachingSite = $(this).closest('tr').find('span#currentTeachingSite').text();
   			$(this).closest('tr').find('div#timePeriod').show();
   			$(this).closest('tr').find('div#teachingSite').show();
   			$(this).closest('tr').find('a#save').show();
   			$(this).closest('tr').find('a#cancel').show();
   			$(this).closest('tr').find('a#delete').show();
   		}
   		return;
	});

	$("a#delete").click(function() {
		$.ajax({
		url: "/tusk/schedule/clinical/admin/ajax/modification",
		data: {
			user_id: user_id,
			course_name: $(this).closest('tr').find('span#courseName').text(),
			current_time_period: currentTimePeriod,
			current_teaching_site: currentTeachingSite,
			school_id: school_id,
			school_db: school_db,
			delete_requested: 'yes'
		}, dataType: "json",
			statusCode: {
				404: function () {
					alert('Page not found');
				},
				500: function () {
					alert('Internal server error');
				},
			}
		}).done(function() {
		}).error(function() {
			alert("An error occured during the deletion process");
		}).success(function(data, status){
			if (data['applied'] == 'true') {
				alert('Student was removed from the requested rotation.');
				location.reload();
			}
			else {
				alert('Student wasn\'t removed from the requested rotation.');
			}
		});
		return;
	});

	$("a#save").click(function() {
		//store the value and wait for the Ajax request result status
		var tempTimePeriod = $(this).closest('tr').find('div#timePeriod').find('select.view').val(); 
		var tempTeachingSite = $(this).closest('tr').find('div#teachingSite').find('select.view').val(); 

		$.ajax({
			url: "/tusk/schedule/clinical/admin/ajax/modification",
			data: {
				user_id: user_id,
				course_name: $(this).closest('tr').find('span#courseName').text(),
				current_time_period: currentTimePeriod,
				current_teaching_site: currentTeachingSite,
				requested_time_period: tempTimePeriod,
				requested_teaching_site: tempTeachingSite,
				school_id: school_id,
				school_db: school_db
			},
			dataType: "json",
			statusCode: {
				404: function () {
					alert('Page not found');
				},
				500: function () {
					alert('Internal server error');
				},
			}
		}).done(function() {
		}).error(function() {
			alert("An error occured during the modification process");
		}).success(function(data, status){
			if (data['applied'] == 'false') {
				alert('Enough students are already enrolled for the given values.');
			}
			else {
				currentTimePeriod = tempTimePeriod;
				currentTeachingSite = tempTeachingSite;
				alert('The time period and teaching site change took place.');
				location.reload();
			}
		});
   		return;
	});
	$("a#cancel").click(function() {
		modificationInProgress = false;
		$(this).closest('tr').find('div#teachingSite').hide();
		$(this).closest('tr').find('div#timePeriod').hide();
		$(this).closest('tr').find('a#save').hide();
		$(this).closest('tr').find('a#cancel').hide();
	});
});