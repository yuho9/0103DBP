// 미션 목록은 JSP가 서버 DB 조회 결과로 출력한다. 이 스크립트는 편집 다이얼로그만 제어한다.
(() => {
    const dialog = document.getElementById('mission-editor');
    if (!dialog) return;
    const form = document.getElementById('mission-editor-form');
    const name = document.getElementById('mission-name');
    const date = document.getElementById('mission-date');
    const action = document.getElementById('mission-editor-action');
    const missionId = document.getElementById('mission-edit-id');
    const todoId = document.getElementById('todo-edit-id');
    const label = document.getElementById('mission-editor-title');
    const contextPath = document.querySelector('link[href*="/css/common.css"]')?.getAttribute('href')?.split('/css/common.css')[0] || '';
    function open(type, edit, button) {
        form.reset();
        form.action = contextPath + (type === 'team' ? '/myproject/mission' : '/myproject/todos');
        action.value = edit ? 'update' : 'create';
        missionId.value = type === 'team' && edit ? button.dataset.id : '';
        todoId.value = type === 'personal' && edit ? button.dataset.id : '';
        name.maxLength = type === 'team' ? 200 : 200;
        name.value = edit ? button.dataset.title : '';
        date.value = edit && button.dataset.date !== 'null' ? button.dataset.date : '';
        label.textContent = `${type === 'team' ? '팀 미션' : '개인 미션'} ${edit ? '수정' : '추가'}`;
        dialog.showModal();
    }
    document.getElementById('team-mission-add')?.addEventListener('click', () => open('team', false));
    document.getElementById('personal-mission-add')?.addEventListener('click', () => open('personal', false));
    document.querySelectorAll('.js-mission-edit').forEach(b => b.addEventListener('click', () => open('team', true, b)));
    document.querySelectorAll('.js-todo-edit').forEach(b => b.addEventListener('click', () => open('personal', true, b)));
    document.getElementById('mission-cancel')?.addEventListener('click', () => dialog.close());
    document.querySelectorAll('.js-confirm-delete').forEach(b => b.closest('form')?.addEventListener('submit', e => {
        if (!confirm('이 미션을 삭제할까요?')) e.preventDefault();
    }));
    // 팀 미션 워크플로: 서버는 기존과 같이 권한·중복·상태를 검증한다.
    // 오류 응답(400/403/404/409 등)은 페이지 이동 없이 팝업으로 안내한다.
    document.querySelectorAll('form[action$="/myproject/mission-workflow"]').forEach(workflowForm => {
        workflowForm.addEventListener('submit', async event => {
            event.preventDefault();
            const action = workflowForm.querySelector('[name="action"]')?.value;
            if (action === 'assign' && !workflowForm.querySelector('[name="targetMemberId"]')?.value) {
                alert('배정할 팀원을 선택하세요.');
                return;
            }
            const button = workflowForm.querySelector('button[type="submit"]');
            if (button?.disabled) return;
            if (button) button.disabled = true;
            try {
                const response = await fetch(workflowForm.action, {
                    method: 'POST',
                    body: new FormData(workflowForm),
                    credentials: 'same-origin',
                    redirect: 'follow'
                });
                // 로그인 만료 시 서버가 로그인 페이지로 리다이렉트할 수 있다.
                if (response.redirected && /\/login(?:[/?#]|$)/.test(new URL(response.url).pathname)) {
                    alert('로그인이 만료되었습니다. 다시 로그인해 주세요.');
                    return;
                }
                if (!response.ok) {
                    let message = '현재 미션 상태에서는 처리할 수 없습니다. 새로고침 후 다시 확인해 주세요.';
                    if (action === 'assign') message = '이미 배정된 팀원이거나 지금 배정할 수 없는 미션입니다.';
                    if (response.status === 403) message = '해당 작업을 수행할 권한이 없습니다.';
                    else if (response.status === 404) message = '작업 주소 또는 미션을 찾을 수 없습니다. 서버 설정을 확인해 주세요.';
                    else if (response.status >= 500) message = '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
                    alert(message);
                    return;
                }
                window.location.reload();
            } catch (error) {
                alert('서버와 통신하지 못했습니다. 연결을 확인해 주세요.');
            } finally {
                if (button) button.disabled = false;
            }
        });
    });
})();
