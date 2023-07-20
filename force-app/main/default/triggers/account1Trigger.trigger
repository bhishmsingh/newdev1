trigger account1Trigger on Account (before insert , before update) {
    
    if(Trigger.isBefore && Trigger.isInsert || Trigger.isBefore && Trigger.isUpdate){
        for(Account acc : trigger.new){
            if(acc.Industry == 'Banking' || acc.Industry == 'Healthcare'){
                
                acc.Rating = 'Hot';
            }
        }
    }

}