(function(){
 'use strict';
 window.qs = function(selector, root) { return (root || document).querySelector(selector); };
 window.qsa = function(selector, root) { return Array.prototype.slice.call((root || document).querySelectorAll(selector)); };
 window.make = function(tag, cls, text) { var el=document.createElement(tag); if(cls)el.className=cls; if(text!==undefined)el.textContent=text; return el; };
 window.stat = function(state) {
   var names={pending:'대기중',accepted:'수락',rejected:'거절',recruiting:'모집중',achieved:'달성',failed:'미달성',active:'참여중',completed:'종료됨'};
   var b=make('span','status '+state,names[state] || '확인 중');return b;
 };
 window.applyCounts = function(){
   var c=TeamDemo.counts(); qsa('[data-count]').forEach(function(el){el.textContent=String(c[el.getAttribute('data-count')] || 0);});
 };
 window.readTab = function(allowed, initial){
   var search=new URLSearchParams(location.search); var tab=search.get('tab'); return allowed.indexOf(tab)>=0?tab:initial;
 };
 window.setupTabs = function(opts){
   var active=readTab(opts.tabs,opts.defaultTab);
   function choose(tab, updateUrl){
     active=tab;
     qsa('[data-tab]').forEach(function(btn){
       var selected=btn.getAttribute('data-tab')===tab;
       btn.classList.toggle('active',selected);btn.setAttribute('aria-selected',String(selected));btn.tabIndex=selected?0:-1;
     });
     qsa('[data-side-tab]').forEach(function(a){
       var selected=a.getAttribute('data-side-tab')===tab;
       a.classList.toggle('active',selected);
       if(selected) a.setAttribute('aria-current','page'); else a.removeAttribute('aria-current');
     });
     if(updateUrl){ var u=new URL(location.href);u.searchParams.set('tab',tab);history.replaceState(null,'',u.toString()); }
     opts.render(tab);
   }
   qsa('[data-tab]').forEach(function(btn){btn.addEventListener('click',function(){choose(btn.getAttribute('data-tab'),true);});});
   /* 사이드바 링크는 원래 하이퍼링크로 남겨둬 JS 없이도 이동 가능 */
   choose(active,false);
   return {current:function(){return active;},refresh:function(){choose(active,false);},choose:choose};
 };
 document.addEventListener('DOMContentLoaded',function(){
   applyCounts();window.addEventListener('demo-data-changed',applyCounts);
 });
})();
