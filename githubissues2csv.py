"""
Exports issues from a list of repositories to individual csv files.
Uses basic authentication (Github username + password) to retrieve issues
from a repository that username has access to. Supports Github API v3.
Forked from: unbracketed/export_repo_issues_to_csv.py
"""
import argparse
import csv
from getpass import getpass
import requests
import json

auth = None
state = 'all'


def write_issues(r, csvout):
    """Parses JSON response and writes to CSV."""
    if r.status_code != 200:
        raise Exception(r.status_code)
    for issue in r.json():
        #print issue['id']
        #print issue['user']['login']

        #return
        if 'pull_request' not in issue:
            labels = ', '.join([l['name'] for l in issue['labels']])
            print labels
            #print issue['assignees']['login']
            #creator1 =   issue['assignees']['login']
            owner1 = issue['user']['login']
            milestone1 = None
            milestone1 = issue['milestone']['title']
            if milestone1 is None:
		 milestone1 = 'none'
            print milestone1
            # print creator1
            date = issue['created_at'].split('T')[0]
            # print issue
            # Change the following line to write out additional fields
            #csvout.writerow([labels, issue['title'], issue['state'], date,
            #                 issue['html_url'], owner1, milestone1, issue['user'], issue['assignees']])

            csvout.writerow([labels, issue['title'], issue['state'], date,
                             issue['html_url'], owner1,  milestone1])

def get_issues(name):
    print "get_issues"
    """Requests issues from GitHub API and writes to CSV file."""
    url = 'https://api.github.com/repos/{}/issues?state={}'.format(name, state)
    #url = 'https://api.zenhub.io/p1/repos/{}/issues?state={}'.format(name, state)
    r = requests.get(url, auth=auth)

    csvfilename = '{}-issues.csv'.format(name.replace('/', '-'))
    with open(csvfilename, 'w') as csvfile:
        csvout = csv.writer(csvfile)
        csvout.writerow(['Labels', 'Title', 'State', 'Date', 'URL', 'Owner', 'Milestone'])
        write_issues(r, csvout)

        # Multiple requests are required if response is paged
        if 'link' in r.headers:
            pages = {rel[6:-1]: url[url.index('<')+1:-1] for url, rel in
                     (link.split(';') for link in
                      r.headers['link'].split(','))}
            while 'last' in pages and 'next' in pages:
                pages = {rel[6:-1]: url[url.index('<')+1:-1] for url, rel in
                         (link.split(';') for link in
                          r.headers['link'].split(','))}
                r = requests.get(pages['next'], auth=auth)
                write_issues(r, csvout)
                if pages['next'] == pages['last']:
                    break


parser = argparse.ArgumentParser(description="Write GitHub repository issues "
                                             "to CSV file.")
parser.add_argument('repositories', nargs='+', help="Repository names, "
                    "formatted as 'username/repo'")
parser.add_argument('--all', action='store_true', help="Returns both open "
                    "and closed issues.")
args = parser.parse_args()

if args.all:
    state = 'all'

#username = input("Username for 'https://github.com': ")
#password = getpass("Password for 'https://{}@github.com': ".format(username))
username = ' '
password = ' '
auth = (username, password)
for repository in args.repositories:
    get_issues(repository)
