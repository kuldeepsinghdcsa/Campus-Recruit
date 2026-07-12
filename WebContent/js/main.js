/* ============================================================
   Campus Recruitment Management System - Main JavaScript
   ============================================================ */

// Auto-dismiss alerts after 4 seconds
document.addEventListener('DOMContentLoaded', function () {

    // Auto-dismiss flash messages
    document.querySelectorAll('.alert.auto-dismiss').forEach(function (el) {
        setTimeout(function () {
            el.style.opacity = '0';
            setTimeout(function () { el.remove(); }, 400);
        }, 4000);
    });

    // Mobile sidebar toggle
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function () {
            sidebar.classList.toggle('open');
        });
    }

    // Table search filter
    const searchInput = document.getElementById('tableSearch');
    const searchableTable = document.querySelector('.searchable-table tbody');
    if (searchInput && searchableTable) {
        searchInput.addEventListener('input', function () {
            const q = this.value.toLowerCase();
            searchableTable.querySelectorAll('tr').forEach(function (row) {
                row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        });
    }

    // Confirm dialog for destructive actions
    document.querySelectorAll('[data-confirm]').forEach(function (el) {
        el.addEventListener('click', function (e) {
            if (!confirm(this.dataset.confirm)) e.preventDefault();
        });
    });

    // Animate stat numbers
    document.querySelectorAll('.stat-value[data-count]').forEach(function (el) {
        const target = parseInt(el.dataset.count, 10);
        let cur = 0;
        const step = Math.max(1, Math.floor(target / 40));
        const timer = setInterval(function () {
            cur = Math.min(cur + step, target);
            el.textContent = cur;
            if (cur >= target) clearInterval(timer);
        }, 30);
    });

    // Chart.js usage (admin dashboard)
    renderAdminCharts();

    // Profile completion progress
    const progressEl = document.querySelector('.profile-progress-fill');
    if (progressEl) {
        const pct = progressEl.dataset.pct;
        progressEl.style.width = '0';
        setTimeout(function () { progressEl.style.width = pct + '%'; }, 100);
    }

    // Export modal
    const exportBtn = document.getElementById('exportBtn');
    const exportModal = document.getElementById('exportModal');
    const closeModal = document.getElementById('closeModal');
    if (exportBtn && exportModal) {
        exportBtn.addEventListener('click', function () { exportModal.classList.add('active'); });
        closeModal.addEventListener('click', function () { exportModal.classList.remove('active'); });
        exportModal.addEventListener('click', function (e) {
            if (e.target === exportModal) exportModal.classList.remove('active');
        });
    }

    // Select/deselect all export fields
    const selectAll = document.getElementById('selectAllFields');
    if (selectAll) {
        selectAll.addEventListener('change', function () {
            document.querySelectorAll('.export-field').forEach(function (cb) {
                cb.checked = selectAll.checked;
            });
        });
    }

    // Active nav highlight
    const currentPath = window.location.pathname;
    document.querySelectorAll('.sidebar-nav a').forEach(function (link) {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href').split('?')[0])) {
            link.classList.add('active');
        }
    });

    // Tab switching
    document.querySelectorAll('.tab-nav .tab').forEach(function (tab) {
        tab.addEventListener('click', function () {
            const group = this.closest('.tab-group');
            group.querySelectorAll('.tab-nav .tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            const target = document.getElementById(this.dataset.target);
            group.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
            if (target) target.style.display = 'block';
        });
    });
    // Initialize first tab
    document.querySelectorAll('.tab-group').forEach(function (group) {
        const tabs = group.querySelectorAll('.tab-nav .tab');
        const contents = group.querySelectorAll('.tab-content');
        if (tabs.length) tabs[0].classList.add('active');
        contents.forEach((c, i) => c.style.display = i === 0 ? 'block' : 'none');
    });
});

/* ---- Chart.js Admin Dashboard ---- */
function renderAdminCharts() {
    if (typeof Chart === 'undefined') return;

    // Placement by department (donut)
    const deptCtx = document.getElementById('deptChart');
    if (deptCtx) {
        const labels = JSON.parse(deptCtx.dataset.labels || '[]');
        const values = JSON.parse(deptCtx.dataset.values || '[]');
        new Chart(deptCtx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: ['#3949ab','#e53935','#00897b','#fb8c00','#8e24aa','#039be5'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'right' } }
            }
        });
    }

    // Placement by company (bar)
    const compCtx = document.getElementById('companyChart');
    if (compCtx) {
        const labels = JSON.parse(compCtx.dataset.labels || '[]');
        const selected = JSON.parse(compCtx.dataset.selected || '[]');
        const total = JSON.parse(compCtx.dataset.total || '[]');
        new Chart(compCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    { label: 'Applied', data: total, backgroundColor: 'rgba(57,73,171,0.2)', borderColor: '#3949ab', borderWidth: 2, borderRadius: 4 },
                    { label: 'Selected', data: selected, backgroundColor: 'rgba(46,125,50,0.8)', borderRadius: 4 }
                ]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'top' } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    }

    // Application trend (line)
    const trendCtx = document.getElementById('trendChart');
    if (trendCtx) {
        const labels = JSON.parse(trendCtx.dataset.labels || '[]');
        const values = JSON.parse(trendCtx.dataset.values || '[]');
        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Applications',
                    data: values,
                    borderColor: '#3949ab',
                    backgroundColor: 'rgba(57,73,171,0.1)',
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#3949ab',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });
    }
}

/* ---- Utility ---- */
function showToast(msg, type) {
    const d = document.createElement('div');
    d.className = 'alert alert-' + (type || 'info');
    d.style.cssText = 'position:fixed;top:20px;right:20px;z-index:9999;min-width:280px;box-shadow:0 4px 20px rgba(0,0,0,0.15)';
    d.textContent = msg;
    document.body.appendChild(d);
    setTimeout(function () { d.remove(); }, 3500);
}

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function () {
        showToast('Copied!', 'success');
    });
}
