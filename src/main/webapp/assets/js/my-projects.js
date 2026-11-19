document.addEventListener('DOMContentLoaded',function(){
 'use strict';
 var root=qs('#project-list');
 var labels={created:'생성한',joined:'참여중',completed:'종료된'};
 function render(tab){
   var d=TeamDemo.load();var items=tab==='joined'?TeamDemo.joinedActive(d):d[tab];
   root.replaceChildren();
   if(!items.length){
     var empty=make('div','empty');empty.append(make('strong','',labels[tab]+' 프로젝트가 없습니다.'));
     empty.append(make('span','', '관련 프로젝트가 생기면 이곳에서 확인할 수 있어요.'));root.append(empty);return;
   }
   items.forEach(function(p){
     var card=make('article','data-card');
     var head=make('div','card-head');head.append(stat(p.state));
     head.append(make('span','small text-muted','프로젝트 · '+p.id));
	 
	 // 프로젝트 제목 영역
	 var titleRow = make('div', 'project-title-row');

	 titleRow.append(make('h2', '', p.title));

	 // 참여중 프로젝트이면서 내가 팀장일 경우
	 if (tab === 'joined' && p.isLeader === true) {
	     var leaderBadge = make(
	         'span',
	         'leader-badge',
	         '👑 팀장'
	     );

	     titleRow.append(leaderBadge);
	 }

	 // 프로젝트 카드에 제목과 설명 추가
	 card.append(
	     head,
	     titleRow,
	     make('p', 'card-subtext', p.description)
	 );
	 
     card.append(make('p','card-footnote','등록일 '+p.date));
     if(tab==='joined'){
       var pr=make('div','progress-row');pr.append(make('span','','프로젝트 진행 현황'),make('strong','',p.progress+'%'));
       var track=make('div','progress-track');track.setAttribute('role','progressbar');track.setAttribute('aria-label',p.title+' 진행률');
       track.setAttribute('aria-valuenow',p.progress);track.setAttribute('aria-valuemin','0');track.setAttribute('aria-valuemax','100');
       var fill=make('div','progress-fill');fill.style.width=p.progress+'%';track.append(fill);card.append(pr,track);
     }
     if(tab==='created' && p.state==='achieved') card.append(make('div','card-detail','달성한 프로젝트는 참여중 목록에도 표시됩니다.'));
     if(tab==='completed') card.append(make('div','card-detail','종료된 프로젝트는 참여중 목록에서 제외됩니다.'));
     root.append(card);
   });
 }
 var tabs=setupTabs({tabs:['created','joined','completed'],defaultTab:'created',render:render});
 function fillChoices(){
   var d=TeamDemo.load();var achieve=qs('#achieve-select');var finish=qs('#finish-select');
   achieve.replaceChildren();finish.replaceChildren();
   d.created.filter(function(x){return x.state==='recruiting';}).forEach(function(p){
     var o=make('option','',p.title);o.value=p.id;achieve.append(o);
   });
   TeamDemo.joinedActive(d).forEach(function(p){var o=make('option','',p.title);o.value=p.id;finish.append(o);});
   qs('#achieve-button').disabled=!achieve.options.length;qs('#finish-button').disabled=!finish.options.length;
 }
 qs('#achieve-button').addEventListener('click',function(){if(TeamDemo.markAchieved(qs('#achieve-select').value)){tabs.refresh();fillChoices();}});
 qs('#finish-button').addEventListener('click',function(){if(TeamDemo.finishProject(qs('#finish-select').value)){tabs.refresh();fillChoices();}});
 qs('#reset-button').addEventListener('click',function(){TeamDemo.reset();tabs.refresh();fillChoices();});
 fillChoices();
});
