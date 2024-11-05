# comet

## Deployment

Deployment of _comet_ is handled by Github Actions. The steps to deploy a change are:

1. Clone the repository

```shell
git clone https://github.com/garettmd/comet.git
```

2. Checkout a feature branch to include updates on

```shell
git checkout -b my-feature
```

3. Make your changes and apply them

```shell
git add .
git commit -m "My commit message"
```

4. Push the branch to Github and start a Pull Request (PR)

```shell
git push -u origin my-feature
```

Open the Pull Request URL provided by the git command output into your browser, and create the PR there.