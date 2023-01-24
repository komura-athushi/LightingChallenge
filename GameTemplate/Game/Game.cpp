#include "stdafx.h"
#include "Game.h"


bool Game::Start()
{
	ModelInitData modelInitData;
	modelInitData.m_tkmFilePath = "Assets/modelData/unityChan.tkm";
	modelInitData.m_fxFilePath = "Assets/shader/model.fx";

	//���C�g�̐F��ݒ�B
	m_lightData.lightColor = { 1.5f,1.5f,1.5f };
	//to do ���C�g�̕�����ݒ�B


	//�萔�o�b�t�@��ݒ�B
	modelInitData.m_expandConstantBuffer = &m_lightData;
	modelInitData.m_expandConstantBufferSize = sizeof(m_lightData);

	m_model.Init(modelInitData);
	return true;
}

void Game::Update()
{
	m_model.UpdateWorldMatrix(Vector3::Zero, Quaternion::Identity, Vector3::One);
}


void Game::Render(RenderContext& rc)
{
	m_model.Draw(rc);
}
