#include "stdafx.h"
#include "Game.h"


bool Game::Start()
{
	ModelInitData modelInitData;
	modelInitData.m_tkmFilePath = "Assets/modelData/unityChan.tkm";
	modelInitData.m_fxFilePath = "Assets/shader/model.fx";

	//ライトの色を設定。
	m_lightData.lightColor = { 1.5f,1.5f,1.5f };
	//ライトの方向を設定。
	m_lightData.lightDirection = { 1,-1,-1 };
	m_lightData.lightDirection.Normalize();
	//カメラ座標を設定。
	m_lightData.eyePos = g_camera3D->GetPosition();

	//定数バッファを設定。
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
