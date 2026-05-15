fetch("assets/amr_summary.tsv")
    .then(response => response.text())
    .then(data => {

        const lines = data.trim().split("\n");

        const tbody = document.querySelector("#amr-table tbody");

        for (let i = 1; i < lines.length; i++) {

            const cols = lines[i].split("\t");

            const row = document.createElement("tr");

            row.innerHTML = `
                <td>${cols[0]}</td>
                <td>${cols[1]}</td>
            `;

            tbody.appendChild(row);
        }
    });