#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("ОбщаяФорма.уатФормаСинхронизацииТСмеждуУАТиВнешнимиСистемами",
		Новый Структура("ТипВнешнейСистемы",ПредопределенноеЗначение("Перечисление.уатТипыВнешнихСистем.СистемаМониторинга")));
КонецПроцедуры

#КонецОбласти
