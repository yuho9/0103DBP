/* UI 시연 전용 데이터: 서버/DB에 연결되지 않습니다. 비밀번호 등의 개인정보는 저장하지 않습니다. */
(function () {
  'use strict';
  var KEY = 'teamMatchingDemo20261113v1';
  function defaults() {
    return {
      created: [
        { id:'p101', title:'캠퍼스 생활을 더 편리하게', description:'학생들을 위한 캠퍼스 편의 서비스 개발', state:'recruiting', date:'2026.11.03', progress:0 },
        { id:'p102', title:'동네 미니 플랫폼', description:'지역 주민을 연결하는 소규모 웹 서비스', state:'achieved', date:'2026.10.21', progress:68, isLeader: true },
        { id:'p103', title:'스터디 기록 서비스', description:'스터디 참여와 일정 관리 앱 제작', state:'failed', date:'2026.09.18', progress:0 }
      ],
      joined: [
        { id:'p201', title:'책 읽는 습관 만들기', description:'독서 기록을 함께 관리하는 팀 프로젝트', state:'active', date:'2026.10.25', progress:42, isLeader: false }
      ],
      completed: [
        { id:'p301', title:'지역 행사 안내 웹사이트', description:'지역 행사를 모아 보는 웹 서비스', state:'completed', date:'2026.08.02', progress:100 }
      ],
      applicants: [
        { id:'a1', project:'캠퍼스 생활을 더 편리하게', person:'김민지', skills:'React · UI 디자인', date:'2026.11.03', note:'프론트엔드 개발에 참여하고 싶습니다.', state:'pending' },
        { id:'a2', project:'캠퍼스 생활을 더 편리하게', person:'정하늘', skills:'Java · SQL', date:'2026.11.04', note:'백엔드 기능 구현에 관심이 있습니다.', state:'pending' }
      ],
      sentOffers: [
        { id:'s1', project:'동네 미니 플랫폼', person:'박서준', skills:'Python · 데이터 분석', date:'2026.11.05', state:'pending' },
        { id:'s2', project:'동네 미니 플랫폼', person:'이도윤', skills:'Figma · React', date:'2026.11.01', state:'accepted' }
      ],
      applied: [
        { id:'ap1', project:'공공데이터 시각화', person:'최지안', date:'2026.11.07', state:'pending' },
        { id:'ap2', project:'웹 접근성 개선', person:'강현우', date:'2026.11.02', state:'accepted' }
      ],
      receivedOffers: [
        { id:'r1', project:'청년 문화 지도', person:'한유진', skills:'React · 지도 API', date:'2026.11.08', note:'지도 화면 구현을 함께해요.', state:'pending' },
        { id:'r2', project:'학교 행사 아카이브', person:'윤도현', skills:'Java · JSP', date:'2026.11.01', note:'서버 구현에 함께할 팀원을 찾고 있습니다.', state:'rejected' }
      ]
    };
  }
  function clone(obj) { return JSON.parse(JSON.stringify(obj)); }
  var fallback = defaults();
  function load() {
    try {
      var raw = localStorage.getItem(KEY);
      if (!raw) return clone(fallback);
      var parsed = JSON.parse(raw);
      var standard = defaults();
      Object.keys(standard).forEach(function(k) { if (!Array.isArray(parsed[k])) parsed[k] = standard[k]; });
      return parsed;
    } catch (e) { return clone(fallback); }
  }
  function save(data) {
    fallback = clone(data);
    try { localStorage.setItem(KEY, JSON.stringify(data)); } catch (e) { /* file:// privacy settings */ }
    window.dispatchEvent(new Event('demo-data-changed'));
  }
  function reset() { save(defaults()); }
  function setDecision(group, id, decision) {
    if (group !== 'applicants' && group !== 'receivedOffers') return false;
    if (decision !== 'accepted' && decision !== 'rejected') return false;
    var data = load();
    var item = data[group].find(function(x) { return x.id === id; });
    if (!item || item.state !== 'pending') return false;
    item.state = decision;
    save(data);
    return true;
  }
  function participation(data) {
    var achievedCreated = data.created.filter(function(x){return x.state === 'achieved';})
      .map(function(x){return Object.assign({},x,{state:'active'});});
    return achievedCreated.concat(data.joined);
  }
  function markAchieved(id) {
    var data = load();
    var item = data.created.find(function(x){return x.id === id;});
    if (!item || item.state !== 'recruiting') return false;
    item.state = 'achieved'; item.progress = 5; save(data); return true;
  }
  function finishProject(id) {
    var data = load();
    var created = data.created.find(function(x){return x.id === id;});
    var joined = data.joined.find(function(x){return x.id === id;});
    var item = created && created.state === 'achieved' ? created : joined;
    if (!item) return false;
    data.completed.push(Object.assign({},item,{state:'completed',progress:100}));
    if (created && created.state === 'achieved') {
      /* 생성한 프로젝트는 원래 목록에 유지; 완료된 프로젝트에도 표시 */
      created.state = 'achieved';
      created.progress = 100;
    } else {
      data.joined = data.joined.filter(function(x){return x.id !== id;});
    }
    save(data); return true;
  }
  function joinedActive(data) {
    var completedIds = new Set(data.completed.map(function(x){return x.id;}));
    return participation(data).filter(function(x){return !completedIds.has(x.id);});
  }
  function counts(data) {
    var d = data || load();
    return {created:d.created.length,joined:joinedActive(d).length,completed:d.completed.length,
      applicants:d.applicants.length,sentOffers:d.sentOffers.length,
      applied:d.applied.length,receivedOffers:d.receivedOffers.length};
  }
  window.TeamDemo = {load:load,save:save,reset:reset,setDecision:setDecision,
    markAchieved:markAchieved,finishProject:finishProject,joinedActive:joinedActive,counts:counts};
})();
