#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("ОбщаяФорма.уатФормаСинхронизацииТСмеждуУАТиВнешнимиСистемами",
		Новый Структура("ТипВнешнейСистемы",ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СервисПарковок")));
КонецПроцедуры

#КонецОбласти
