search = decodeURIComponent(location.search)
param = {
    availability: search.indexOf('?availability') isnt -1 or search.indexOf('&availability') isnt -1
    technicians: (search.split('?technicians=')[1] or search.split('&technicians=')[1] or '').split('&')[0]

    assignment: search.indexOf('?assignment') isnt -1 or search.indexOf('&assignment') isnt -1
    areas: (search.split('?areas=')[1] or search.split('&areas=')[1] or '').split('&')[0]
    services: (search.split('?services=')[1] or search.split('&services=')[1] or '').split('&')[0]
    options: (search.split('?options=')[1] or search.split('&options=')[1] or '').split('&')[0]
}

momentToApex = (obj) -> obj.toJSON().split('.')[0].replace('T', ' ')

if not param.availability
    filterable = true
    manualViewRender = false

loadResources = (cb) ->
    $.ajax {
        url: "#{url}?loadResources"#{if param.areas then "&areas=#{param.areas}" else ''}#{if param.technicians then "&technicians=#{param.technicians}" else ''}"
        xhrFields: { withCredentials: true }
        success: (data) ->
            cb _.chain(data).filter((obj) ->
                if filterable
                    selects = $multiFilter.multipleSelect('getSelects')
                    services = if obj.Service_Type__c then ("s:#{v}" for v in obj.Service_Type__c.split(';')) else []
                    return "a:#{obj.Area__c}" in selects and _.intersection(services, selects).length and (if "o:Availability" in selects then not obj.Calendar_Items__r else true)
                return obj.Id[...15] in (id[...15] for id in param.technicians.split(';'))
            ).map((obj) -> {
                id: obj.Id
                title: obj.Name
                area: obj.Area__c
                user: obj.User__c
                dailyNote: obj.Daily_Note__c or ''
            }).sortBy('area').value()
            if filterable
                $scheduler.fullCalendar('option', 'viewRender').call($scheduler.fullCalendar('getView')) if manualViewRender
                manualViewRender = true
    }

loadEvents = (start, end, timezone, cb) ->
    $.ajax {
        url: "#{url}?loadEvents&start=#{start.toJSON()}&end=#{end.toJSON()}"#{if param.areas then "&areas=#{param.areas}" else ''}#{if param.technicians then "&technicians=#{param.technicians}" else ''}"
        xhrFields: { withCredentials: true }
        success: (data) ->
            cb _.map(data, (obj) -> {
                id: obj.Id
                title: if obj.Work_Order__r then "#{obj.Work_Order__r.Name} - #{obj.Name}, Status: #{obj.Status__c}" else 'Unavailable'
                status: if not obj.Work_Order__r then 'Unavailable' else obj.Status__c
                start: obj.Start_Date_and_Time__c
                end: obj.End_Date_and_Time__c
                #status: obj.Status__c
                resourceId: obj.Technician__c
                color: if not obj.Work_Order__r then 'red' else switch obj.Status__c
                    when 'Assigned' then 'green'
                    when 'Appointment' then 'yellow'
                    when 'Decline' then 'gray'
                    when 'Confirmed' then 'lightblue'
                    when 'En Route' then 'orange'
                    when 'Loaded' then 'purple'
                    when 'Finished' then 'blue'
                    when 'Canceled' then 'black'
                    else 'slategray'
            })
    }

setNowBackground = ->
    now = moment()
    mm = Number(now.format('mm'))
    mm = if mm < 30 then '00' else '30'
    now = "#{now.format('HH')}:#{mm}:00"
    $('.now-background').removeClass('now-background')
    $("tr[data-time='#{now}']").addClass('now-background')
setInterval(setNowBackground, 1000 * 10) # every 10 secs

setInterval((->
  $scheduler.fullCalendar('refetchResources')
  $scheduler.fullCalendar('refetchEvents')
), 1000 * 60) # every 60 secs

$scheduler = $('#scheduler').fullCalendar({
    defaultView: if param.availability then 'agendaWholeWeek' else 'agendaDay'
    timezone: 'local'
    allDaySlot: false
    handleWindowResize: false
    height: 'parent'
    header: {
        left: 'prev,next today'
        center: 'title'
        right: 'agendaDay,agendaTwoDays,agendaThreeDays'
    }
    resources: loadResources
    events: loadEvents
    views: {
        agendaTwoDays: {
            type: 'agenda'
            duration: { days: 2 }
            groupByResource: true
        }
        agendaThreeDays: {
            type: 'agenda'
            duration: { days: 3 }
            groupByResource: true
        }
        agendaWholeWeek: {
            type: 'agenda'
            duration: { days: 7 }
            groupByResource: true
        }
    }
    viewRender: ->
        setNowBackground()
        days = { agendaDay: 1, agendaTwoDays: 2, agendaThreeDays: 3, agendaWholeWeek: 7 }[@type]
        resources = $scheduler.fullCalendar('getResources')
        $thead = $scheduler.find('.fc-row.fc-widget-header thead')
        i = 0
        for tech in $thead.find('th:not(:first)')
            $(tech).append('<u>(U)</u>') if resources[i++].user

        $areas = $thead.find('tr:first').clone()
        $areas.find('th:not(:first)').remove()
        for area, count of _.countBy(resources, 'area')
            $areas.append("<th class='fc-resource-cell' colspan='#{days * count}'>#{area}</th>")

        $daily = $thead.find('tr:first').clone()
        $daily.find('th:not(:first)').remove()
        for dailyNote in _.pluck(resources, 'dailyNote')
            $daily.append("<th class='fc-resource-cell'>#{dailyNote}</th>")

        $thead.prepend($areas)
        $thead.append($daily)
    eventClick: if param.availability then (event, jsEvent, view) ->
            return if event.status isnt 'Unavailable'
            $event.splice(0)[0].css('opacity', ''); $event.push($(@))
            $event[0].css('opacity', '0.75').data('id', event.id);
            $removeUnavailablity.removeClass('fc-state-disabled').attr('disabled', false)
            $markAsUnavailable.addClass('fc-state-disabled').attr('disabled', true)
    selectable: param.assignment or param.availability
    select: (start, end, jsEvent, view, resource) ->
        if param.assignment
            parent.postMessage([momentToApex(start), momentToApex(end), resource.id], '*')
        else
            $event.splice(0)[0].css('opacity', ''); $event.push($())
            $removeUnavailablity.addClass('fc-state-disabled').attr('disabled', true)
            selected.splice(0); selected.push(momentToApex(start), momentToApex(end), resource.id)
            $markAsUnavailable.removeClass('fc-state-disabled').attr('disabled', false)
})

if filterable
    layouts = sforce.connection.describeLayout('Technician__c')
    pls = _.find(layouts.recordTypeMappings, ((rtm) -> rtm.defaultRecordTypeMapping)).picklistsForRecordType
    areasValues = _.sortBy(_.map(_.find(pls, ((pls) -> pls.picklistName is 'Area__c')).picklistValues, ((plv) -> plv.value)))
    serviceValues = _.sortBy(_.map(_.find(pls, ((pls) -> pls.picklistName is 'Service_Type__c')).picklistValues, ((plv) -> plv.value)))
    #areasValues = 'ASTN,DLS,FW,HSTN,OKC,SA'.split(',')
    #serviceValues = 'Locksmith,RSA,Towing'.split(',')
    optionsValues = 'Availability'.split(',')
    $multiFilter = $('<select multiple="multiple"><optgroup label="Area:">{areas}</optgroup><optgroup label="Service Type:">{service}</optgroup><optgroup label="More Options:">{options}</optgroup></select>'
        .replace('{areas}', ("<option value='a:#{v}' #{if not param.areas then 'selected' else if v in param.areas.split(';') then 'selected' else ''}>#{v}</option>" for v in areasValues).join(''))
        .replace('{service}', ("<option value='s:#{v}' #{if not param.services then 'selected' else if v in param.services.split(';') then 'selected' else ''}>#{v}</option>" for v in serviceValues).join(''))
        .replace('{options}', ("<option value='o:#{v}' #{if not param.options then 'selected' else if v in param.options.split(';') then 'selected' else ''}>#{v}</option>" for v in optionsValues).join('')))
    $scheduler.find('.fc-right').prepend($multiFilter)
    $multiFilter.multipleSelect({onClose: (-> $scheduler.fullCalendar('refetchResources'))})
    $('.ms-parent').find('input[type="checkbox"][data-name="selectGroup"]').remove()

if param.availability
    $event = [$()]
    selected = []
    $scheduler.find('.fc-right .fc-button-group').remove()
    $backToTechnician = $('<button>Back To Technician</button>')
        .addClass('fc-button fc-state-default fc-corner-left fc-corner-right')
        .click ->
            open("/#{$scheduler.fullCalendar('getResources')[0].id}", '_parent')
    $removeUnavailablity = $('<button>Remove Unavailablity</button>')
        .addClass('fc-button fc-state-default fc-corner-left fc-corner-right fc-state-disabled')
        .attr('disabled', true)
        .click ->
            $removeUnavailablity.addClass('fc-state-disabled').attr('disabled', true)
            sforce.apex.executeAnonymous """
            Calendar_Item__c event = new Calendar_Item__c(Id='#{$event[0].data('id')}');
            delete event;
            """
            $scheduler.fullCalendar('refetchEvents')
    $markAsUnavailable = $('<button>Mark as Unavailable</button>')
        .addClass('fc-button fc-state-default fc-corner-left fc-corner-right fc-state-disabled')
        .attr('disabled', true)
        .click ->
            $markAsUnavailable.addClass('fc-state-disabled').attr('disabled', true)
            sforce.apex.executeAnonymous """
            Calendar_Item__c event = new Calendar_Item__c();
            event.Start_Date_and_Time__c = Datetime.valueOfGmt('#{selected[0]}');
            event.End_Date_and_Time__c = Datetime.valueOfGmt('#{selected[1]}');
            event.Technician__c = '#{selected[2]}';
            insert event;
            """
            $scheduler.fullCalendar('refetchEvents')
    $scheduler.find('.fc-right').append($markAsUnavailable).append($removeUnavailablity).append($backToTechnician)

$(window).resize(-> $scheduler.fullCalendar('option', 'height', @innerHeight)).resize()
