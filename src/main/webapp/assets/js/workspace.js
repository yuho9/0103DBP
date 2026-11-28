document.querySelectorAll('.sidebar a').forEach(a => { if (new URL(a.href).pathname === location.pathname) a.classList.add('active'); });
const form=document.getElementById('todo-form');
if(form){const items=document.getElementById('todo-items');let seq=0;function add(text){const row=document.createElement('div');row.className='task';const check=document.createElement('input');check.type='checkbox';check.id='task-'+(++seq);const label=document.createElement('label');label.htmlFor=check.id;label.textContent=text;const edit=document.createElement('button');edit.textContent='수정';edit.type='button';edit.onclick=()=>{const v=prompt('할 일 수정',label.textContent);if(v&&v.trim())label.textContent=v.trim()};const del=document.createElement('button');del.textContent='삭제';del.type='button';del.onclick=()=>row.remove();row.append(check,label,edit,del);items.append(row)}add('프로젝트 상세 화면 정리');add('로그인 상태 화면 확인');form.addEventListener('submit',e=>{e.preventDefault();const input=document.getElementById('todo-text');if(input.value.trim())add(input.value.trim());input.value=''});}

const board=document.getElementById('mission-board');if(board){const stages=['진행 중','승인 대기','승인 완료'];function refresh(){const cols=board.querySelectorAll('section');let total=0;cols.forEach(col=>{const n=col.querySelectorAll('.mission').length;col.querySelector('h3 span').textContent=n;total+=n});const done=cols[2].querySelectorAll('.mission').length;document.getElementById('mission-progress').textContent='진행률 '+(total?Math.round(done/total*100):0)+'% · 승인 완료 '+done+' / 전체 '+total}board.addEventListener('click',e=>{if(!e.target.classList.contains('move'))return;const card=e.target.closest('.mission');const next=Number(card.parentElement.dataset.stage)+1;board.querySelector('[data-stage="'+next+'"]').append(card);card.querySelector('.tag').textContent=stages[next];if(next===2)e.target.remove();else e.target.textContent='팀장 승인';refresh()});document.getElementById('new-mission').onclick=()=>{const name=prompt('미션 이름');if(!name||!name.trim())return;const card=document.createElement('article');card.className='panel mission';const tag=document.createElement('span');tag.className='tag';tag.textContent=stages[0];const title=document.createElement('h3');title.textContent=name.trim();const button=document.createElement('button');button.className='btn move';button.textContent='내 작업 완료';card.append(tag,title,button);board.querySelector('[data-stage="0"]').append(card);refresh()}}

const calendar = document.getElementById('weekly-calendar');
if (calendar) {
    const days = ['월','화','수','목','금','토','일'];
    const avRoot = document.getElementById('db-availability');
    const myMemberId = Number(avRoot?.dataset.myMemberId || 0);
    const memberIds = [...(avRoot?.querySelectorAll('.db-availability-member') || [])]
        .map(el => Number(el.dataset.memberId)).filter(n => n > 0);
    const members = [...(avRoot?.querySelectorAll('.db-availability-member') || [])].map(el => ({
        id: Number(el.dataset.memberId),
        name: el.dataset.memberName || `팀원 #${el.dataset.memberId}`,
        leader: el.dataset.leader === 'true'
    }));
    const people = members.map(m => m.name);
    const colors = ['#d9e7f4','#e4d3ef','#f5e2bc','#d9ead0','#f5ced4','#d6e8e7'];
    const memberSlots = new Map(memberIds.map(id => [id, new Set()]));
    const minute = hhmm => Number(hhmm.slice(0,2))*60 + Number(hhmm.slice(3,5));
    for (const el of avRoot?.querySelectorAll('.db-availability-range') || []) {
        const id = Number(el.dataset.memberId), d = Number(el.dataset.day) - 1;
        const startMin = minute(el.dataset.start), endMin = minute(el.dataset.end);
        const startSlot = Math.floor(startMin/30);
        const endSlot = endMin === 1439 ? 48 : Math.floor(endMin/30);
        if (!memberSlots.has(id) || d < 0 || d > 6) continue;
        for (let t = startSlot; t < endSlot; t++) memberSlots.get(id).add(`${d}-${t}`);
    }
    const first = 0, last = 48;
    const dbRoot = document.getElementById('db-schedules');
    const projectId = dbRoot?.dataset.projectId || '';
    const contextPath = dbRoot?.dataset.contextPath || '';
    const dbEvents = [...(dbRoot?.querySelectorAll('.db-event') || [])].map(el => ({
        id: Number(el.dataset.id), name: el.dataset.title,
        description: el.dataset.description || '',
        startAt: el.dataset.start.slice(0,16), endAt: el.dataset.end.slice(0,16),
        canEdit: el.dataset.canEdit === 'true'
    }));

    const dateKey = d => `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`;
    const addDays = (d,n) => { const x=new Date(d); x.setDate(x.getDate()+n); return x; };
    let week = new Date(); week.setHours(0,0,0,0); week=addDays(week,-((week.getDay()+6)%7));
    const time = n => `${String(Math.floor(n/2)).padStart(2,'0')}:${n%2?'30':'00'}`;
    const key = (d,t) => `${d}-${t}`;
    const current = () => {
        const k=dateKey(week);
        // 일정은 항상 서버 GET 결과로 구성한다. localStorage의 예전 임시 일정은 사용하지 않는다.
        const events = dbEvents.filter(e => {
            const day = e.startAt.slice(0,10);
            return day >= k && day <= dateKey(addDays(week,6));
        }).map(e => {
            const day = days.findIndex((_,i) => dateKey(addDays(week,i)) === e.startAt.slice(0,10));
            const hhmm = iso => { const h=Number(iso.slice(11,13)), m=Number(iso.slice(14,16)); return h*2 + (m>=30 ? 1 : 0); };
            return {...e, day, start:hhmm(e.startAt), end:e.endAt.slice(0,10) > e.startAt.slice(0,10) && e.endAt.slice(11,16)==='00:00' ? 48 : hhmm(e.endAt)};
        });
        return {mine: [...(memberSlots.get(myMemberId) || new Set())], events};
    };
    const available = (i,d,t) => (memberSlots.get(memberIds[i]) || new Set()).has(key(d,t));
    const heading = () => `${dateKey(week)} ~ ${dateKey(addDays(week,6))}`;
    const legend=document.getElementById('calendar-legend');
    people.concat(['공통 가능','팀 일정']).forEach((name,i)=>{const span=document.createElement('span');span.className='legend-item';const dot=document.createElement('i');dot.style.background=i<people.length?colors[i%colors.length]:(i===people.length?'#a5c69b':'#650d2b');span.append(dot);if(i<members.length&&members[i].leader){const title=document.createElement('strong');title.className='leader-name';title.textContent=name;span.append(title,document.createTextNode(' · 팀장'));}else{span.append(document.createTextNode(name));}legend.append(span);});
    function build(table,editing) {
        const head=table.tHead, body=table.tBodies[0];head.replaceChildren();body.replaceChildren();
        const tr=head.insertRow();const th=document.createElement('th');th.textContent='시간';tr.append(th);
        days.forEach((name,d)=>{const h=document.createElement('th');const date=addDays(week,d);h.textContent=`${name} ${date.getMonth()+1}/${date.getDate()}`;if(dateKey(date)===dateKey(new Date()))h.className='today';tr.append(h);});
        const eventsForWeek = editing ? [] : current().events;
        // 일주일 전체에 가능 시간이 없고 팀 일정도 없는 연속 시간대만 접는다.
        const emptyAcrossWeek = t => !editing &&
            !memberIds.some(id => { const slots=memberSlots.get(id); return days.some((_,d)=>slots && slots.has(key(d,t))); }) &&
            !eventsForWeek.some(e => t>=e.start && t<e.end);
        for(let t=first;t<last;){
            if(emptyAcrossWeek(t)) {
                const start=t;
                while(t<last && emptyAcrossWeek(t)) t++;
                const row=body.insertRow(); row.className='calendar-collapsed';
                const td=row.insertCell();td.colSpan=8;
                const button=document.createElement('button');button.type='button';button.className='calendar-expand';
                button.textContent=`▸ ${time(start)} ~ ${time(t)} · 모두 불가능한 시간 (${(t-start)*30}분) · 펼치기`;
                button.setAttribute('aria-expanded','false');
                button.onclick=()=>{
                    const expanded=button.getAttribute('aria-expanded')==='true';
                    button.setAttribute('aria-expanded',String(!expanded));
                    button.textContent=expanded?`▸ ${time(start)} ~ ${time(t)} · 모두 불가능한 시간 · 펼치기`:`▾ ${time(start)} ~ ${time(t)} · 다시 접기`;
                    for(const r of [...body.rows]) if(r.dataset.fold===`${start}`)r.hidden=expanded;
                };
                td.append(button);
                for(let slot=start;slot<t;slot++) {
                    const detail=body.insertRow();detail.className='calendar-fold-detail';detail.dataset.fold=String(start);detail.hidden=true;
                    const th=document.createElement('th');th.textContent=time(slot);detail.append(th);
                    for(let d=0;d<7;d++)detail.insertCell();
                }
                continue;
            }
            const row=body.insertRow();const label=document.createElement('th');label.textContent=time(t);row.append(label);
            for(let d=0;d<7;d++){
                const td=row.insertCell();td.dataset.slot=key(d,t);
                if(editing){const button=document.createElement('button');button.type='button';button.className='slot';button.dataset.slot=key(d,t);button.setAttribute('aria-label',`${days[d]} ${time(t)}`);td.append(button);continue;}
                const all=people.length>0 && people.every((_,i)=>available(i,d,t));if(all)td.classList.add('common-slot');
                people.forEach((name,i)=>{if(available(i,d,t)){const tag=document.createElement('span');tag.className='person-slot';tag.style.background=colors[i%colors.length];tag.textContent=name;td.append(tag);}});
                eventsForWeek.filter(e=>e.day===d&&t>=e.start&&t<e.end).forEach(e=>{const tag=document.createElement('span');tag.className='event-slot';tag.textContent=e.name;td.append(tag);});
            }
            t++;
        }
    }
    function renderTeamSchedule() {
        const list = document.getElementById('team-schedule-list');
        if (!list) return;
        list.replaceChildren();
        const events = [...current().events].sort((a,b) => a.day-b.day || a.start-b.start || a.end-b.end);
        if (!events.length) {
            const empty = document.createElement('p');
            empty.className = 'muted';
            empty.textContent = '이번 주 등록된 팀 일정이 없습니다.';
            list.append(empty);
            return;
        }
        // 같은 날짜의 팀 일정은 날짜를 한 번만 표시하고 옆으로 나열한다.
        const grouped = new Map();
        for (const event of events) {
            const key = event.day;
            if (!grouped.has(key)) grouped.set(key, []);
            grouped.get(key).push(event);
        }
        grouped.forEach((dayEvents, day) => {
            const date = addDays(week, day);
            const group = document.createElement('div');
            group.className = 'schedule-day-row';
            const dateLabel = document.createElement('strong');
            dateLabel.className = 'schedule-day-label';
            dateLabel.textContent = `${date.getMonth()+1}/${date.getDate()} (${days[day]})`;
            const eventWrap = document.createElement('div');
            eventWrap.className = 'schedule-day-events';
            dayEvents.forEach(event => {
                const card = document.createElement('div');
                card.className = 'schedule-event-card';
                const name = document.createElement('strong');
                name.textContent = event.name;
                const detail = document.createElement('small');
                detail.textContent = `${time(event.start)} ~ ${time(event.end)}`;
                card.append(name, detail);
                if (event.canEdit) {
                    const buttons = document.createElement('div');
                    buttons.className = 'schedule-event-actions';
                    const edit = document.createElement('button');
                    edit.type = 'button'; edit.className = 'btn secondary'; edit.textContent = '수정';
                    edit.onclick = () => openEventEditor(event);
                    const del = document.createElement('button');
                    del.type = 'button'; del.className = 'btn secondary'; del.textContent = '삭제';
                    del.onclick = () => {
                        if (!confirm('이 팀 일정을 삭제할까요?')) return;
                        const form = document.createElement('form');
                        form.method = 'post'; form.action = contextPath + '/myproject/schedule';
                        [['projectId', projectId], ['scheduleId', String(event.id)], ['action', 'delete']].forEach(([k, v]) => {
                            const input = document.createElement('input');
                            input.type = 'hidden'; input.name = k; input.value = v; form.append(input);
                        });
                        document.body.append(form); form.submit();
                    };
                    buttons.append(edit, del); card.append(buttons);
                }
                eventWrap.append(card);
            });
            group.append(dateLabel, eventWrap);
            list.append(group);
        });
    }
    function render(){
        renderTeamSchedule();
        document.getElementById('week-title').textContent=heading();
        build(calendar,false);
        const list=document.getElementById('availability-list');
        list.replaceChildren();
        for(let d=0;d<7;d++){
            const ranges=[];
            let t=first;
            while(t<last){
                if(!people.length || !people.every((_,i)=>available(i,d,t))){t++;continue;}
                const start=t;
                while(t<last && people.every((_,i)=>available(i,d,t)))t++;
                ranges.push(`${time(start)} ~ ${time(t)}`);
            }
            if(!ranges.length)continue;
            const group=document.createElement('div'); group.className='availability-day-row';
            const label=document.createElement('strong');label.className='availability-day-label';
            label.textContent=days[d]+'요일';
            const times=document.createElement('div');times.className='availability-day-times';
            ranges.forEach(range=>{const span=document.createElement('span');span.className='tag';span.textContent=range;times.append(span);});
            group.append(label,times);list.append(group);
        }
        if(!list.children.length)list.textContent='모든 팀원이 가능한 시간이 없습니다.';
    }
    document.getElementById('prev-week').onclick=()=>{week=addDays(week,-7);render();};
    document.getElementById('next-week').onclick=()=>{week=addDays(week,7);render();};
    const dialog=document.getElementById('availability-dialog'), grid=document.getElementById('availability-grid');let draft=new Set(), dragging=false, paint=true;
    function update(){grid.querySelectorAll('button.slot').forEach(b=>{const selected=draft.has(b.dataset.slot);b.classList.toggle('selected',selected);b.setAttribute('aria-pressed',String(selected));});document.getElementById('selected-count').textContent=`선택한 시간: ${draft.size*30}분`;}
    function apply(b){if(!b)return;if(paint)draft.add(b.dataset.slot);else draft.delete(b.dataset.slot);update();}
    document.getElementById('available').onclick=()=>{if(!myMemberId){alert('ACTIVE 팀원만 가능 시간을 저장할 수 있습니다.');return;}draft=new Set(current().mine);document.getElementById('input-week').textContent=heading();build(grid,true);update();dialog.showModal();};
    grid.addEventListener('pointerdown',e=>{const b=e.target.closest('button.slot');if(!b||e.button!==0)return;e.preventDefault();dragging=true;paint=!draft.has(b.dataset.slot);apply(b);});
    grid.addEventListener('pointermove',e=>{if(!dragging)return;const b=document.elementFromPoint(e.clientX,e.clientY)?.closest('button.slot');if(b&&grid.contains(b))apply(b);});
    window.addEventListener('pointerup',()=>dragging=false);window.addEventListener('pointercancel',()=>dragging=false);
    grid.addEventListener('click',e=>{const b=e.target.closest('button.slot');if(b&&e.detail===0){paint=!draft.has(b.dataset.slot);apply(b);}});
    document.getElementById('clear-availability').onclick=()=>{draft.clear();update();};
    document.getElementById('close-availability').onclick=()=>dialog.close();
    document.getElementById('save-availability').onclick=()=>{
        // 드래그한 30분 칸을 연속 시간 범위로 합친 뒤 서버에 전송한다.
        const ranges=[];
        for(let d=0;d<7;d++){
            let t=0;
            while(t<48){
                if(!draft.has(key(d,t))){t++;continue;}
                const start=t;
                while(t<48&&draft.has(key(d,t)))t++;
                ranges.push(`${d+1},${time(start)},${t===48?'23:59':time(t)}`);
            }
        }
        document.getElementById('availability-ranges').value=ranges.join(';');
        document.getElementById('availability-save-form').submit();
    };
    const eventDialog=document.getElementById('schedule-dialog'), start=document.getElementById('event-start'), end=document.getElementById('event-end');
    for(let t=first;t<=last;t++){if(t<last)start.add(new Option(time(t),t));if(t>first)end.add(new Option(time(t),t));}
    function openEventEditor(event) {
        const form = document.getElementById('schedule-form'); form.reset();
        document.getElementById('schedule-action').value=event ? 'update' : 'create';
        document.getElementById('schedule-id').value=event ? event.id : '';
        document.getElementById('schedule-form-heading').textContent=event ? '일정 수정' : '일정 추가';
        document.getElementById('save-event').textContent=event ? '수정 저장' : '등록';
        const input=document.getElementById('event-date');
        input.min=dateKey(week); input.max=dateKey(addDays(week,6));
        input.value=event ? event.startAt.slice(0,10) : input.min;
        document.getElementById('event-name').value=event?.name || '';
        document.getElementById('event-description').value=event?.description || '';
        start.value=event ? String(event.start) : '34';
        end.value=event ? String(event.end) : '36';
        eventDialog.showModal();
    }
    document.getElementById('schedule').onclick=()=>openEventEditor(null);
    document.getElementById('cancel-event').onclick=()=>eventDialog.close();
    document.getElementById('schedule-form').onsubmit=e=>{
        const name=document.getElementById('event-name').value.trim();
        const date=document.getElementById('event-date').value;
        const day=days.findIndex((_,i)=>dateKey(addDays(week,i))===date);
        if(!name||day<0||Number(start.value)>=Number(end.value)){
            e.preventDefault(); alert('일정 이름과 날짜, 시간 범위를 확인하세요.'); return;
        }
        document.getElementById('schedule-start-at').value=date+'T'+time(Number(start.value));
        document.getElementById('schedule-end-at').value=Number(end.value)===48 ? dateKey(addDays(new Date(date+'T12:00:00'),1))+'T00:00' : date+'T'+time(Number(end.value));
        // 브라우저 POST -> ScheduleController -> ScheduleDAO -> Oracle.
    };
    render();
}
