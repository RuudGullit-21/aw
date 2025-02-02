
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПолучитьПроцентКомиссии();
	Элементы.ШтрафыСоздатьСчет.Заголовок = ?(ЗначениеЗаполнено(Объект.IDСчета),
	Нстр("ru = 'Получить счет в PDF'"),
	Нстр("ru = 'Создать счет и получить в PDF'"));

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПолучитьПроцентКомиссииСервер();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	Если Объект.IDРеестра
		<> уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.Ссылка, "IDРеестра") Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура СуммаОплачиваемыхПостановленийПриИзменении(Элемент)
	ПолучитьПроцентКомиссии();
КонецПроцедуры

&НаКлиенте
Процедура ИтоговаяСтоимостьПриИзменении(Элемент)
	ПолучитьПроцентКомиссии();
КонецПроцедуры

&НаКлиенте
Процедура КомиссияПриИзменении(Элемент)
	ПолучитьПроцентКомиссии();
КонецПроцедуры

&НаКлиенте
Процедура IDСчетаПриИзменении(Элемент)
	Элементы.ШтрафыСоздатьСчет.Заголовок = ?(ЗначениеЗаполнено(Объект.IDСчета),
	Нстр("ru = 'Получить счет в PDF'"),
	Нстр("ru = 'Создать счет и получить в PDF'"));
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПолучитьРеестр(Команда)
	
	ФайлСсылка = Неопределено;
	ПолучитьРеестрСервер(ФайлСсылка);
	Если ЗначениеЗаполнено(ФайлСсылка) Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка, Неопределено, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчет(Команда)
	
	ФайлСсылка = Неопределено;
	ЗагрузитьСчетСервер(ФайлСсылка);
	
	Если ЗначениеЗаполнено(ФайлСсылка) Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка, Неопределено, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКвитанцию(Команда)
	ТекущиеДанные = Элементы.Штрафы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФайлСсылка = Неопределено;
	ПолучитьКвитанциюСервер(ФайлСсылка, ТекущиеДанные.Штраф);
	Если ЗначениеЗаполнено(ФайлСсылка) Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка, Неопределено, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПолучитьПроцентКомиссии()
	ПроцентКомиссия = ?(ЗначениеЗаполнено(Объект.ИтоговаяСтоимость), Окр((Объект.Комиссия * 100) / Объект.ИтоговаяСтоимость), 0);
	Элементы.ПроцентКомиссии.Заголовок = ?(ЗначениеЗаполнено(ПроцентКомиссия), Строка(ПроцентКомиссия) + "%", "");
КонецПроцедуры

&НаСервере
Процедура ПолучитьПроцентКомиссииСервер()
	ПроцентКомиссия = ?(ЗначениеЗаполнено(Объект.ИтоговаяСтоимость),  Окр((Объект.Комиссия * 100) / Объект.ИтоговаяСтоимость), 0);
	Элементы.ПроцентКомиссии.Заголовок = ?(ЗначениеЗаполнено(ПроцентКомиссия), Строка(ПроцентКомиссия) + "%", "");
КонецПроцедуры

&НаСервере
Процедура ПолучитьРеестрСервер(ФайлСсылка)
	
	Если ЗначениеЗаполнено(Объект.IDРеестра)
		И Объект.Штрафы.Количество() <> 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Штрафы[0].Штраф.УчетнаяЗапись) Тогда
			УчетныеЗаписиСервисаШтрафов = Объект.Штрафы[0].Штраф.УчетнаяЗапись;
		Иначе
			УчетныеЗаписиСервисаШтрафов = Объект.Штрафы[0].Штраф.ТС.УчетнаяЗаписьCервисаШтрафов;
		КонецЕсли;

		ТекстОшибки = "";
		ФайлСсылка = Неопределено;
		КодВозврата = уатИнтеграции_проф.ШтрафовНет_ИнформацияРеестра(УчетныеЗаписиСервисаШтрафов,
		Объект.Ссылка, Объект.IDРеестра, ТекстОшибки, ФайлСсылка);
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКвитанциюСервер(ФайлСсылка, Штраф)
	
	Если ЗначениеЗаполнено(Объект.IDРеестра)
		И Объект.Штрафы.Количество() <> 0 Тогда
		
		Если ЗначениеЗаполнено(Штраф.УчетнаяЗапись) Тогда
			УчетныеЗаписиСервисаШтрафов = Штраф.УчетнаяЗапись;
		Иначе
			УчетныеЗаписиСервисаШтрафов = Штраф.ТС.УчетнаяЗаписьCервисаШтрафов;
		КонецЕсли;
	
		ТекстОшибки = "";
		ФайлСсылка = Неопределено;
		КодВозврата = уатИнтеграции_проф.ШтрафовНет_ИнформацияРеестраКвитанция(УчетныеЗаписиСервисаШтрафов,
		Объект.Ссылка, Объект.IDРеестра, Штраф.НомерПостановления, ТекстОшибки, ФайлСсылка);
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСчетСервер(ФайлСсылка)
	
	Если НЕ ЗначениеЗаполнено(Объект.IDРеестра) Тогда
		ТекстОшибки = Нстр("ru = 'Не заполнено ID реестра в сервисе штрафов'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если Объект.Штрафы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Штрафы[0].Штраф.УчетнаяЗапись) Тогда
		УчетныеЗаписиСервисаШтрафов = Объект.Штрафы[0].Штраф.УчетнаяЗапись;
	Иначе
		УчетныеЗаписиСервисаШтрафов = Объект.Штрафы[0].Штраф.ТС.УчетнаяЗаписьCервисаШтрафов;
	КонецЕсли;
	
	ТекстОшибки = "";
	IDСчета     = Объект.IDСчета;
	уатИнтеграции_проф.ШтрафовНет_СозданиеСчета(УчетныеЗаписиСервисаШтрафов, Объект.Ссылка, Объект.IDРеестра, ТекстОшибки, ФайлСсылка, IDСчета);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Если ЗначениеЗаполнено(IDСчета) Тогда
			Объект.IDСчета = IDСчета;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Счет на оплату успешно выставлен.'"));
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	Иначе
		Объект.IDСчета = IDСчета;
		Элементы.ШтрафыСоздатьСчет.Заголовок = Нстр("ru = 'Получить счет в PDF'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	Если Объект.Штрафы.Количество() Тогда 
		ТекстНСТР = НСтр("en='Clear the list of orders before the selection?';ru='Очистить список штрафов перед подбором?'");
		Оповещение = Новый ОписаниеОповещения("ПодборШтрафоОчисткаТЧ", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстНСТР, РежимДиалогаВопрос.ДаНетОтмена);
	Иначе 
		ПодборШтрафовОткрытьФормуПодбора();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборШтрафоОчисткаТЧ(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда 
		Объект.Штрафы.Очистить();
		
		ПодборШтрафовОткрытьФормуПодбора();
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ПодборШтрафовОткрытьФормуПодбора();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборШтрафовОткрытьФормуПодбора()
	
	Оповещение = Новый ОписаниеОповещения("ПодборШтрафовПослеПодбора", ЭтотОбъект);
	ОткрытьФорму("Документ.уатШтраф.Форма.ФормаВыбора", 
		Новый Структура("МножественныйВыбор", Истина), ЭтотОбъект,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборШтрафовПослеПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из РезультатЗакрытия Цикл 
		НоваяСтрока = Объект.Штрафы.Добавить();
		НоваяСтрока.Штраф = ТекСтрока;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
