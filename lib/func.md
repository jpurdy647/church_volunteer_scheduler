Data:
    Data-sources:
        Cloud:
            Google drive:
                .sched
    Local:
        .sched
    
    Rapid save and close
        Maintain data copy, verify no file changes before next resave
            notify if file has been modified externally, should it be overwritten?


Logic:
    Logging:
        Every person scheduled will have the data used to schedule them saved in their slot, for debugging purposes.
            Tabled people
            Rotation iterator counter



UI:
    Spreadsheet view
        Data Layout:
            Multiple activiers in view simultaneously
            configureation filter will dictacte which columns are printed and whic cells are printed
            columns filtered by activity:role
            activity is a stacked header
            role is column name
            filters can hide that data based on columns
            some activities will be less frequent and some rows will have empty cells due to no activity at that time
        App Bar:
            Data Source Title
            Datasource Button
        Upper row (Interaction):
            Enable Disable Editing

        Action Bar/Rail:
            Filter view based on:
                Date Range
                Activities
                Roles
            Wand:
                **Be Aware, scheduling will take into account activities or roles that are hidden**
                Fill in Schedule:
                    Full regeneration
                    Partial Regeneration
                        Fill in gaps with best rotation  
            Config:
                Link to config view
            More (...):
                Share:
                    Data Export Modal Window:
                        Select export style:
                            CSV
                            Clipboard
                        Select Export Range
                            Full Sched
                            Full Sched including saved history
                            Selected region with headers
                            selected region with no added headers
                Stats:
                    Display stats view:
                        Left sidebar:
                            List all available charts
                                on click scroll to view chart
                        Right side main view:
                            Grid of all charts.
                    Pie charts for all roles curenttly displayed
                    custom pie charts can also be configured for display
                    ordered by roles order in spreasdsheet
                    Provides verification
        Body:
            Spread Sheet:
                on cell click:
                    if pending action:
                        (select range, etc) complete action
                    else:
                        Edit mode enabled:
                            Convert to textbox for editing
                        Edit mode disabled:
                            select
    
    Data Source View:
        If no connection:
            Message: No data source is loaded
                Recent Data Sources:
                    If there are any
                Cloud:
                    Google:
                Local:
                    File ui
        If Connected already:
            Show Data source location and name
            Switch to different or new data source:
                Switches to the new data source view as above as if no data source is connected
                    History will back up to the previous (this) page
            Clone current work to a new data source and switch to it
            Save a backup of current data to new data source
            Create a new blank data source

    Config View
        Tabs:
            Scheduling:
                Length of Sched history to store
                Highlight all occurances of person on cell click
            Activities:
                Everything is date based, activity name per date
                List activities
                    Edit/delete existing entries
                Create new Activity:
                    Activity:
                        Date start
                        Date End?
                        Frequency:
                            x times per date
                            date:
                                daily, weekly, monthly, yearly
                        Roles:
                            Constraint Groups:
                                Day Group //flag on repeat within same day
                                Activity Group //flag on repeat in same activity only
                                Custom Time Frame Group: //flag if repeat within custom defined date range
                                    Weekly (Which DOW is start?)
                                    Monthly
                            Priority //defines order in whc=ich roles are scheduled
                            Rotation Start // override first person to be scheduled
                                Option: Checkbox
                            Persons array:
                                Name
                                Frequency boost (Maybe reduction also?)
                
