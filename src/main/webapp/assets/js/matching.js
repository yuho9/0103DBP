document.addEventListener('DOMContentLoaded',function(){
 'use strict';
 var mode=document.body.getAttribute('data-matching-mode');
 var configs=mode==='leader'
  ?{applicants:{label:'내 프로젝트 지원자',group:'applicants',actionable:true},sent:{label:'보낸 팀원 제안',group:'sentOffers',actionable:false}}
  :{applied:{label:'지원한 프로젝트',group:'applied',actionable:false},received:{label:'받은 팀원 제안',group:'receivedOffers',actionable:true}};
 var allowed=Object.keys(configs),root=qs('#matching-list');var tabs;
 function render(tab){
   var spec=configs[tab];if(!spec)return;
   var items=TeamDemo.load()[spec.group];root.replaceChildren();
   if(!items.length){var e=make('div','empty');e.append(make('strong','',spec.label+' 목록이 없습니다.'));e.append(make('span','','새로운 활동이 등록되면 여기에서 확인할 수 있습니다.'));root.append(e);return;}
   items.forEach(function(item){
     var card=make('article','data-card matching-card');var left=make('div');
     var h=make('div','card-head');h.append(stat(item.state));h.append(make('span','small text-muted',item.date));left.append(h);
     left.append(make('h2','',item.project));
     var line=spec.group==='applicants'?'지원자: '+item.person:
       spec.group==='sentOffers'?'제안 대상: '+item.person:
       spec.group==='applied'?'프로젝트 운영자: '+item.person:'제안한 운영자: '+item.person;
     left.append(make('p','card-meta',line));
     var detail=make('div','card-detail');
     detail.textContent=spec.group==='applicants'?'프로젝트에 지원한 사용자의 신청 내용입니다.':
       spec.group==='sentOffers'?'보낸 팀원 제안에 대한 상대방의 응답을 확인합니다.':
       spec.group==='applied'?'프로젝트 운영자의 수락 또는 거절 결과가 표시됩니다.':
       '받은 팀원 제안을 확인하고 수락 또는 거절할 수 있습니다.';
     left.append(detail);
     if(spec.actionable&&item.state==='pending'){
       var actions=make('div','card-actions');
       [['수락','accepted','btn primary small'],['거절','rejected','btn danger small']].forEach(function(pair){
         var b=make('button',pair[2],pair[0]);b.type='button';b.addEventListener('click',function(){
           var message=pair[1]==='accepted'?'수락':'거절';
           if(!window.confirm(item.person+'님의 요청을 '+message+'하시겠습니까?'))return;
           if(TeamDemo.setDecision(spec.group,item.id,pair[1])) tabs.refresh();
         });actions.append(b);
       });left.append(actions);
     }else{
       var note=item.state==='pending'?'상대방의 답변을 기다리고 있습니다.':item.state==='accepted'?'수락 완료된 항목입니다.':'거절 처리된 항목입니다.';
       left.append(make('p','status-note',note));
     }
     var right=make('div','matching-person');
     var cap=spec.group==='applicants'?'지원자 정보':spec.group==='receivedOffers'?'운영자 정보':spec.group==='sentOffers'?'제안받은 팀원':'프로젝트 정보';
     right.append(make('h3','',cap),make('p','person-name',item.person));
     right.append(make('p','',item.skills || '프로젝트 담당자'));
     if(item.note)right.append(make('p','card-footnote',item.note));
     card.append(left,right);root.append(card);
   });
 }
 tabs=setupTabs({tabs:allowed,defaultTab:allowed[0],render:render});
});
