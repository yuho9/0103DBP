function initMissionList() {
    const page = document.getElementById('mission-list-page');
    if (!page || page.dataset.initialized === "true") return;
    page.dataset.initialized = "true";
    let leader = page.dataset.leader === 'true';
    let nextId = 7;
    const missions = [
        {id:1,type:'team',name:'공통 개발환경 구성',date:'2026-11-13',status:2},
        {id:2,type:'team',name:'로그인 · 회원 기능',date:'2026-11-19',status:1},
        {id:3,type:'team',name:'서비스 기능 구현',date:'2026-11-26',status:0},
        {id:4,type:'personal',name:'대시보드 화면 구현',date:'2026-11-16',status:2},
        {id:5,type:'personal',name:'미션 관리 DAO 구현',date:'2026-11-19',status:1},
        {id:6,type:'personal',name:'일정 관리 기능 구현',date:'2026-11-23',status:0}
    ];
    const labels = ['진행 중','승인 대기','완료'];
    const icons = ['○','◷','✓'];
    const classes = ['ongoing','pending','complete'];
    const get = id => document.getElementById(id);
    const canEdit = type => type === 'personal' || leader;
    const dialog = get('mission-editor');
    function showEditor() {
        if (typeof dialog.showModal === "function") { dialog.showModal(); }
        else { dialog.setAttribute("open", ""); dialog.classList.add("mission-dialog-fallback"); }
    }
    function closeEditor() {
        if (typeof dialog.close === "function") dialog.close();
        else { dialog.removeAttribute("open"); dialog.classList.remove("mission-dialog-fallback"); }
    }
    let editing = null;
    function button(label, action, title) {
        const b = document.createElement('button');
        b.type = 'button'; b.className = 'btn secondary mission-action'; b.textContent = label;
        if (title) { b.title = title; b.setAttribute('aria-label',title); }
        b.onclick = action; return b;
    }
    function openEditor(type, mission) {
        if (!canEdit(type)) return;
        editing = {type, id:mission ? mission.id : null};
        get('mission-editor-title').textContent = mission ? '미션 수정' : '미션 추가';
        get('mission-name').value = mission ? mission.name : '';
        get('mission-date').value = mission ? mission.date : '';
        showEditor();
    }
    function render() {
        const add = get('team-mission-add');
        add.hidden = !leader;
        add.disabled = !leader;
        add.style.display = leader ? 'inline-block' : 'none';
        ['team','personal'].forEach(type => {
            const list = get(type+'-mission-items'); list.replaceChildren();
            const items = missions.filter(m => m.type === type);
            const done = items.filter(m => m.status === 2).length;
            get(type+'-mission-count').textContent = `${done} / ${items.length} 완료`;
            const progress = get(type+'-mission-progress'); progress.max = Math.max(1,items.length); progress.value = done;
            if (!items.length) { const empty=document.createElement('p'); empty.className='muted mission-empty'; empty.textContent='등록된 미션이 없습니다.'; list.append(empty); }
            items.forEach(m => {
                const row=document.createElement('article'); row.className='mission-row';
                const icon=document.createElement('span'); icon.className='mission-icon '+classes[m.status]; icon.textContent=icons[m.status]; icon.title=labels[m.status]; icon.setAttribute('aria-label',labels[m.status]);
                const info=document.createElement('div'); info.className='mission-info';
                const name=document.createElement('strong'); name.textContent=m.name; if(m.status===2)name.className='mission-done';
                const meta=document.createElement('small'); meta.textContent=(m.date ? '마감 '+m.date+' · ' : '')+labels[m.status];
                info.append(name,meta); row.append(icon,info);
                const actions=document.createElement('div'); actions.className='mission-actions';
                if(m.status===0) actions.append(button('완료 요청',()=>{m.status=1;render();}));
                if(m.status===1 && leader) actions.append(button('승인',()=>{if(leader){m.status=2;render();}}));
                if(canEdit(type)) {
                    actions.append(button('수정',()=>openEditor(type,m)));
                    actions.append(button('삭제',()=>{if(canEdit(type)&&confirm('미션을 삭제할까요?')){missions.splice(missions.indexOf(m),1);render();}}));
                }
                row.append(actions); list.append(row);
            });
        });
    }
    get('team-mission-add').onclick=()=>openEditor('team',null);
    get('personal-mission-add').onclick=()=>openEditor('personal',null);
    get('mission-cancel').onclick=()=>closeEditor();
    get('mission-editor-form').onsubmit=e=>{
        e.preventDefault(); if(!editing||!canEdit(editing.type))return;
        const name=get('mission-name').value.trim(), date=get('mission-date').value;
        if(!name)return;
        if(editing.id===null)missions.push({id:nextId++,type:editing.type,name,date,status:0});
        else {const m=missions.find(x=>x.id===editing.id);if(m){m.name=name;m.date=date;}}
        closeEditor();render();
    };
    const role=get('mission-preview-role');
    if (role && page.dataset.preview === 'true') {
        leader = role.value === 'leader';
        role.addEventListener('change', () => {
            leader = role.value === 'leader';
            if (dialog.open) closeEditor();
            render();
        });
    }
    render();
}
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initMissionList);
} else {
    initMissionList();
}
