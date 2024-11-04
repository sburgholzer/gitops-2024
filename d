name: Check Grafana Port

on:
    schedule:
        - cron: '0 * * * *'
    workflow_dispatch:  # Allows manual triggering

permissions:
  issues: write
  contents: read

jobs:
    check-grafana:
        runs-on: ubuntu-latest
        environment: production

        steps:
            - name: Check Grafana HTTP Accessibility
              id: check_port
              continue-on-error: true
              run: |
                if curl -f -s -o /dev/null http://${{ secrets.GRAFANA_IP }}:3000; then
                  echo "result=true" >> $GITHUB_OUTPUT
                else
                  echo "result=false" >> $GITHUB_OUTPUT
                fi
            
            - name: Get Formatted Date
              id: date
              run: |
                echo "date=$(TZ='America/Chicago' date +'%m-%d-%y %I:%M %p %Z')" >> $GITHUB_OUTPUT
            
            - name: Find Existing Issue
              if: steps.check_port.outputs.result != 'true'
              uses: micalevisk/last-issue-action@v2
              id: last_issue
              with:
                token: ${{ secrets.GITHUB_TOKEN }}
                state: open
                labels: grafana,infrastructure,port-inaccessible
            
            - name: Create Issue If The Port Is Not Accessible
              if: steps.check_port.outputs.result != 'true' && steps.last_issue.outputs.has-found != 'true'
              uses: dacbd/create-issue-action@main
              with:
                token: ${{ secrets.GITHUB_TOKEN }}
                title: "🚨 Grafana Port Inaccessible"
                labels: grafana,infrastructure,port-inaccessible
                body: |
                    Grafana port inaccessible detected at ${{ steps.date.outputs.date }}

                    The Grafana port 3000 is not accessible. Please check Security Groups, instance status, etc.
                    
                    [View Workflow Run](${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }})
            
            - name: Add Comment If Issue Exists
              if: steps.check_port.outputs.result !=
